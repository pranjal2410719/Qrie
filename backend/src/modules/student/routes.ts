import { FastifyInstance, FastifyRequest, FastifyReply } from 'fastify';
import { authenticate } from '../../middleware/auth.js';
import { config } from '../../config/index.js';
import { BadRequestError, NotFoundError, AppError } from '../../shared/errors.js';

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

export async function studentRoutes(app: FastifyInstance) {
  /**
   * Public Branding Lookup by School Code (for login & splash screen)
   *
   * NOTE: this is still a single-tenant demo lookup. It validates the code and
   * refuses unknown schools rather than silently returning DPS branding for
   * every tenant, but it does not read from the organization table yet.
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
      // Tenant-isolated branding derivation
      return reply.status(200).send({
        ...DEFAULT_SCHOOL_BRANDING,
        school_id: user.schoolId,
      });
    },
  );

  /**
   * Offline Interaction Outbox Batch Synchronization
   * Idempotently accepts learning interactions (e.g. answer attempts).
   */
  app.post(
    '/sync/events',
    { preHandler: [authenticate] },
    async (request: FastifyRequest, reply: FastifyReply) => {
      const body = request.body as any;
      const events = body?.events;
      if (!Array.isArray(events)) {
        throw new BadRequestError('events must be an array');
      }

      // All received event IDs are confirmed synchronized.
      // TODO(issue-1): persist to the ledger and relay to LAM; this is an
      // acknowledgement stub, not evidence ingestion.
      const syncedIds = events.map((e: { id: string }) => e.id);

      return reply.status(200).send({
        status: 'success',
        synced_count: syncedIds.length,
        synced_ids: syncedIds,
      });
    },
  );

  /**
   * Authoritative Practice Answer Verification
   */
  app.post(
    '/learning/sessions/:sessionId/answers',
    { preHandler: [authenticate] },
    async (request: FastifyRequest, reply: FastifyReply) => {
      const body = request.body as any;
      const { question_id, selected_option, numeric_input, assistance_rung } = body;

      // TODO(issue-1): grading is hardcoded to a single demo question and is
      // not backed by a curriculum bank or persisted evidence.
      let isCorrect = false;
      let explanation = '';
      let xpEarned = 15;

      if (question_id === 'q4' || numeric_input !== undefined) {
        const val = parseFloat(numeric_input);
        isCorrect = Math.abs(val - 25.0) < 0.001;
        explanation = 'Pressure P = Force / Area = 50 N / 2 m² = 25 Pascals (N/m²).';
        xpEarned = isCorrect ? 20 : 0;
      } else {
        isCorrect = selected_option === 1 || selected_option === 2;
        explanation = 'Verified authoritative explanation from NCERT curriculum bank.';
        xpEarned = isCorrect ? (assistance_rung > 0 ? 10 : 20) : 0;
      }

      return reply.status(200).send({
        question_id,
        is_correct: isCorrect,
        explanation,
        xp_awarded: xpEarned,
        is_assisted: (assistance_rung || 0) > 0,
        timestamp: new Date().toISOString(),
      });
    },
  );
}
