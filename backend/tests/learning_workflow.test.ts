import { describe, it, expect, beforeAll, vi } from 'vitest';
import { buildApp } from '../src/app.js';
import { lamRecommendationSchema } from '../src/modules/student/contracts.js';
import * as relayModule from '../src/modules/student/relay.js';

describe('Authoritative Learning Workflow & Recommendations', () => {
  const app = buildApp();
  let studentToken: string;

  beforeAll(async () => {
    await app.ready();
    studentToken = app.jwt.sign({
      id: 'std_aarav_patel',
      email: 'aarav@school.edu',
      role: 'student',
      schoolId: 'sch_dps_rkp',
    });
  });

  describe('GET /api/v1/learning/recommendations/next', () => {
    it('rejects unauthenticated requests with HTTP 401', async () => {
      const res = await app.inject({
        method: 'GET',
        url: '/api/v1/learning/recommendations/next?concept_id=physics.mechanics.pressure',
      });

      expect(res.statusCode).toBe(401);
      const body = res.json();
      expect(body.title).toBe('UNAUTHORIZED');
    });

    it('rejects request with missing concept_id query parameter with HTTP 400', async () => {
      const res = await app.inject({
        method: 'GET',
        url: '/api/v1/learning/recommendations/next',
        headers: {
          authorization: `Bearer ${studentToken}`,
        },
      });

      expect(res.statusCode).toBe(400);
      const body = res.json();
      expect(body.title).toBe('BAD_REQUEST');
      expect(body.detail).toContain('concept_id');
    });

    it('returns a schema-compliant fallback recommendation when LAM service is offline', async () => {
      const res = await app.inject({
        method: 'GET',
        url: '/api/v1/learning/recommendations/next?concept_id=physics.mechanics.pressure',
        headers: {
          authorization: `Bearer ${studentToken}`,
        },
      });

      expect(res.statusCode).toBe(200);
      const body = res.json();

      // Validate against the canonical Zod schema
      const parsed = lamRecommendationSchema.safeParse(body);
      expect(parsed.success).toBe(true);

      expect(body.safe_fallback).toBe(true);
      expect(body.reason_code).toBe('LAM_UNREACHABLE_FALLBACK');
      expect(body.target_concept_id).toBe('physics.mechanics.pressure');
    });
  });

  describe('POST /api/v1/learning/sessions/:sessionId/answers', () => {
    it('rejects unauthenticated answer submissions with HTTP 401', async () => {
      const res = await app.inject({
        method: 'POST',
        url: '/api/v1/learning/sessions/sess_101/answers',
        payload: {
          question_id: 'q4',
          numeric_input: 25,
        },
      });

      expect(res.statusCode).toBe(401);
    });

    it('rejects malformed answer payload with HTTP 400', async () => {
      const res = await app.inject({
        method: 'POST',
        url: '/api/v1/learning/sessions/sess_101/answers',
        headers: {
          authorization: `Bearer ${studentToken}`,
        },
        payload: {},
      });

      expect(res.statusCode).toBe(400);
      const body = res.json();
      expect(body.title).toBe('BAD_REQUEST');
    });

    it('grades correct numeric question (q4) authoritatively and generates event metadata', async () => {
      const res = await app.inject({
        method: 'POST',
        url: '/api/v1/learning/sessions/sess_101/answers',
        headers: {
          authorization: `Bearer ${studentToken}`,
        },
        payload: {
          question_id: 'q4',
          numeric_input: 25,
          assistance_rung: 0,
          duration_ms: 3200,
        },
      });

      expect(res.statusCode).toBe(200);
      const body = res.json();

      expect(body.question_id).toBe('q4');
      expect(body.session_id).toBe('sess_101');
      expect(body.is_correct).toBe(true);
      expect(body.xp_awarded).toBe(20);
      expect(body.is_assisted).toBe(false);
      expect(body.concept_ids).toEqual(['physics.mechanics.pressure']);
      expect(body.event_id).toBeDefined();
      expect(body.timestamp).toBeDefined();
    });

    it('grades incorrect numeric question authoritatively with 0 XP', async () => {
      const res = await app.inject({
        method: 'POST',
        url: '/api/v1/learning/sessions/sess_101/answers',
        headers: {
          authorization: `Bearer ${studentToken}`,
        },
        payload: {
          question_id: 'q4',
          numeric_input: 12.5,
          assistance_rung: 0,
        },
      });

      expect(res.statusCode).toBe(200);
      const body = res.json();

      expect(body.is_correct).toBe(false);
      expect(body.xp_awarded).toBe(0);
    });

    it('grades multiple-choice question (q1) with assistance rung reduction', async () => {
      const res = await app.inject({
        method: 'POST',
        url: '/api/v1/learning/sessions/sess_101/answers',
        headers: {
          authorization: `Bearer ${studentToken}`,
        },
        payload: {
          question_id: 'q1',
          selected_option: 2,
          assistance_rung: 1,
        },
      });

      expect(res.statusCode).toBe(200);
      const body = res.json();

      expect(body.question_id).toBe('q1');
      expect(body.is_correct).toBe(true);
      expect(body.xp_awarded).toBe(10); // Reduced due to assistance
      expect(body.is_assisted).toBe(true);
      expect(body.concept_ids).toEqual(['physics.mechanics.force']);
    });

    it('triggers non-blocking relayPendingEvents after persisting answer event', async () => {
      const relaySpy = vi.spyOn(relayModule, 'relayPendingEvents').mockResolvedValue({
        attempted: 1,
        relayed: 1,
        skipped: 0,
        failed: 0,
      });

      const res = await app.inject({
        method: 'POST',
        url: '/api/v1/learning/sessions/sess_relay_test/answers',
        headers: {
          authorization: `Bearer ${studentToken}`,
        },
        payload: {
          question_id: 'q4',
          numeric_input: 25,
          assistance_rung: 0,
        },
      });

      expect(res.statusCode).toBe(200);
      expect(relaySpy).toHaveBeenCalledWith('sch_dps_rkp', 'std_aarav_patel');
    });
  });
});
