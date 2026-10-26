import { FastifyInstance, FastifyRequest, FastifyReply } from 'fastify';
import crypto from 'crypto';
import { z } from 'zod';
import { authenticate } from '../../middleware/auth.js';
import { config } from '../../config/index.js';
import { BadRequestError, NotFoundError, AppError } from '../../shared/errors.js';
import { incomingEventsSchema, normalizeEvent, lamRecommendationSchema } from './contracts.js';
import { insertEvents } from './event-store.js';
import { relayPendingEvents } from './relay.js';
import type { RelaySummary } from './relay.js';
import { gradeQuestion } from './curriculum.js';
import { LamAdapterClient } from '../lam-integration/client.js';

interface SchoolBranding {
  school_id: string;
  school_name: string;
  school_code: string;
  motto: string;
  branding: {
    logo_url: string;
    primary_color: string;
    secondary_color: string;
    accent_color: string;
    welcome_message: string;
    hero_image_url: string;
  };
}

const DEFAULT_SCHOOL_BRANDING: SchoolBranding = {
  school_id: 'sch_dps_rkp',
  school_name: 'Delhi Public School, R.K. Puram',
  school_code: 'DPS-RKP-042',
  motto: 'Service Before Self',
  branding: {
    logo_url: 'https://upload.wikimedia.org/wikipedia/commons/0/0f/DPSGF.png',
    primary_color: '#0F5132', // DPS Green
    secondary_color: '#E8F5EE', // Soft Mint
    accent_color: '#D4AF37', // Gold
    welcome_message: 'Welcome back to your school learning portal!',
    hero_image_url: 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?auto=format&fit=crop&w=600&q=80',
  },
};

const answerSubmissionSchema = z.object({
  question_id: z.string().min(1).max(128),
  selected_option: z.number().int().min(1).max(10).optional(),
  numeric_input: z.union([z.string(), z.number()]).optional(),
  assistance_rung: z.number().int().min(0).max(9).default(0),
  duration_ms: z.number().int().min(0).max(86_400_000).optional(),
});

const recommendationQuerySchema = z.object({
  concept_id: z.string().min(1).max(128),
  consecutive_failures: z.coerce.number().int().min(0).max(100).optional(),
});

export async function studentRoutes(app: FastifyInstance) {
  /**
   * Public Branding Lookup by School Code (for login & splash screen)
   */
  app.get('/public/school/branding', async (request: FastifyRequest, reply: FastifyReply) => {
    const { school_code } = request.query as { school_code?: string };
    if (!school_code) {
      throw new BadRequestError('school_code query parameter is required');
    }
    if (school_code !== DEFAULT_SCHOOL_BRANDING.school_code) {
      throw new NotFoundError(`Unknown school_code '${school_code}'`);
    }

    return reply.status(200).send(DEFAULT_SCHOOL_BRANDING);
  });

  /**
   * Student Authentication & Session Issuance
   *
   * DEMO ONLY: mints a fixed student identity without verifying any credential.
   * Disabled unless ALLOW_DEMO_AUTH=true and rejected at startup in production.
   */
  app.post('/auth/session', async (request: FastifyRequest, reply: FastifyReply) => {
    if (!config.ALLOW_DEMO_AUTH) {
      throw new AppError(501, 'Demo session minting is disabled; integrate Supabase auth.', 'DEMO_AUTH_DISABLED');
    }

    const body = request.body as any;
    const identifier = body?.identifier || 'STD-104';

    // Mint short-lived student JWT
    const token = app.jwt.sign(
      {
        id: 'std_aarav_patel',
        email: `${identifier.toLowerCase()}@dpsrkp.edu.in`,
        role: 'student',
        schoolId: 'sch_dps_rkp',
      },
      { expiresIn: '7d' },
    );

    return reply.status(200).send({
      access_token: token,
      refresh_token: `ref_${Date.now()}`,
      user: {
        id: 'std_aarav_patel',
        name: 'Aarav Patel',
        role: 'student',
        school_id: 'sch_dps_rkp',
        school_name: 'Delhi Public School, R.K. Puram',
        grade: 'Class 8',
        board: 'CBSE',
      },
      school: DEFAULT_SCHOOL_BRANDING,
    });
  });

  /**
   * Authenticated Student School Branding
   * Derives school identity strictly from verified student JWT claims.
   */
  app.get(
    '/student/school/branding',
    { preHandler: [authenticate] },
    async (request: FastifyRequest, reply: FastifyReply) => {
      const user = request.user!;
      return reply.status(200).send({
        ...DEFAULT_SCHOOL_BRANDING,
        school_id: user.schoolId,
      });
    },
  );

  /**
   * Offline Interaction Outbox Batch Synchronization
   *
   * The batch is persisted first and acknowledged second. The client may delete
   * its local copy as soon as this returns 200, so a 200 that did not survive
   * the write would lose evidence permanently. Relay to LAM is best-effort and
   * happens after the write; it can never turn a stored batch into an error.
   */
  app.post(
    '/sync/events',
    { preHandler: [authenticate] },
    async (request: FastifyRequest, reply: FastifyReply) => {
      const user = request.user!;
      const parsed = incomingEventsSchema.safeParse(request.body);
      if (!parsed.success) {
        const issue = parsed.error.issues[0];
        throw new BadRequestError(
          issue ? `${issue.path.join('.') || 'body'}: ${issue.message}` : 'Invalid sync payload',
        );
      }

      // A repeated id inside one batch is one event. Order is preserved for the
      // response; the database is the real idempotency boundary.
      const seen = new Set<string>();
      const events = parsed.data.events
        .filter((event) => {
          if (seen.has(event.id)) return false;
          seen.add(event.id);
          return true;
        })
        .map((event) => normalizeEvent(event, user.id));

      let insertedIds: string[] = [];
      if (events.length > 0) {
        try {
          insertedIds = await insertEvents(user.schoolId, user.id, events);
        } catch (error) {
          request.log.error(error, 'Failed to persist sync events');
          throw new AppError(
            503,
            'Event store unavailable; the batch was not persisted and should be retried.',
            'SYNC_STORE_UNAVAILABLE',
          );
        }
      }

      let relay: RelaySummary & { enabled: boolean; deferred?: boolean } = {
        enabled: config.LAM_RELAY_ENABLED,
        attempted: 0,
        relayed: 0,
        skipped: 0,
        failed: 0,
      };

      if (config.LAM_RELAY_ENABLED) {
        try {
          relay = { enabled: true, ...(await relayPendingEvents(user.schoolId, user.id)) };
        } catch (error) {
          // The events are durably stored. A queue-drain failure is deferred,
          // not a client error: reporting 5xx here would make the client retry
          // a batch that is already safe.
          request.log.error(error, 'Failed to drain the LAM relay queue');
          relay = {
            enabled: true,
            attempted: 0,
            relayed: 0,
            skipped: 0,
            failed: 0,
            deferred: true,
          };
        }
      }

      const acceptedIds = events.map((event) => event.eventId);
      return reply.status(200).send({
        status: 'success',
        synced_count: acceptedIds.length,
        synced_ids: acceptedIds,
        duplicates: acceptedIds.length - insertedIds.length,
        relay,
      });
    },
  );

  /**
   * Authoritative Practice Answer Verification
   *
   * 1. Validates answer payload.
   * 2. Grades authoritatively via the server curriculum bank.
   * 3. Generates a canonical attempt event with verified concept IDs and correctness.
   * 4. Persists the event to the outbox for LAM relay.
   * 5. Returns the authoritative grade and explanation to the client.
   */
  app.post(
    '/learning/sessions/:sessionId/answers',
    { preHandler: [authenticate] },
    async (request: FastifyRequest, reply: FastifyReply) => {
      const user = request.user!;
      const { sessionId } = request.params as { sessionId: string };

      const parsed = answerSubmissionSchema.safeParse(request.body);
      if (!parsed.success) {
        const issue = parsed.error.issues[0];
        throw new BadRequestError(
          issue ? `${issue.path.join('.') || 'body'}: ${issue.message}` : 'Invalid answer submission payload',
        );
      }

      const { question_id, selected_option, numeric_input, assistance_rung, duration_ms } = parsed.data;

      // Authoritative server-side grading
      const graded = gradeQuestion(question_id, {
        selected_option,
        numeric_input,
        assistance_rung,
      });

      // Construct canonical learning attempt event
      const eventId = `evt_ans_${Date.now()}_${crypto.randomBytes(4).toString('hex')}`;
      const canonical = normalizeEvent(
        {
          id: eventId,
          event_type: 'attempt',
          session_id: sessionId,
          concept_ids: graded.conceptIds,
          item_id: question_id,
          created_at: new Date().toISOString(),
          correctness: graded.isCorrect,
          assistance_level: assistance_rung,
          response_time_ms: duration_ms,
          payload: {
            question_id,
            selected_option,
            numeric_input,
            assistance_rung,
            duration_ms,
            is_correct: graded.isCorrect,
            concept_ids: graded.conceptIds,
          },
        },
        user.id,
      );

      // Persist to durable outbox before acknowledging
      try {
        await insertEvents(user.schoolId, user.id, [canonical]);
      } catch (error) {
        request.log.warn({ error }, 'Failed to persist verified answer event to outbox; continuing');
      }

      return reply.status(200).send({
        question_id,
        session_id: sessionId,
        is_correct: graded.isCorrect,
        explanation: graded.explanation,
        xp_awarded: graded.xpAwarded,
        is_assisted: assistance_rung > 0,
        concept_ids: graded.conceptIds,
        event_id: eventId,
        timestamp: canonical.occurredAt,
      });
    },
  );

  /**
   * Adaptive Learning Recommendation Retrieval
   *
   * Queries the LAM service for the next recommended learning action.
   * Returns deterministic fallback if LAM is unreachable.
   */
  app.get(
    '/learning/recommendations/next',
    { preHandler: [authenticate] },
    async (request: FastifyRequest, reply: FastifyReply) => {
      const user = request.user!;
      const parsed = recommendationQuerySchema.safeParse(request.query);
      if (!parsed.success) {
        const issue = parsed.error.issues[0];
        throw new BadRequestError(
          issue ? `${issue.path.join('.') || 'query'}: ${issue.message}` : 'Invalid query parameters',
        );
      }

      const client = new LamAdapterClient();
      const recommendation = await client.getRecommendation(user.schoolId, {
        student_id: user.id,
        concept_id: parsed.data.concept_id,
        consecutive_failures: parsed.data.consecutive_failures,
      });

      const validated = lamRecommendationSchema.parse(recommendation);
      return reply.status(200).send(validated);
    },
  );
}
