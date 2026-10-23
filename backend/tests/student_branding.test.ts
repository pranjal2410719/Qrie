import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import { FastifyInstance } from 'fastify';
import { buildApp } from '../src/app.js';

describe('Student Application API & School Branding', () => {
  let app: FastifyInstance;

  beforeAll(async () => {
    app = buildApp();
    await app.ready();
  });

  afterAll(async () => {
    await app.close();
  });

  const studentToken = () =>
    app.jwt.sign({
      id: 'std_01',
      email: 'student@school.edu',
      role: 'student',
      schoolId: 'sch_dps_rkp',
    });

  it('GET /api/v1/public/school/branding returns Delhi Public School verified branding', async () => {
    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/public/school/branding?school_code=DPS-RKP-042',
    });

    expect(res.statusCode).toBe(200);
    const body = JSON.parse(res.body);
    expect(body.school_name).toBe('Delhi Public School, R.K. Puram');
    expect(body.branding.primary_color).toBe('#0F5132');
    expect(body.branding.logo_url).toContain('upload.wikimedia.org');
    expect(body.motto).toBe('Service Before Self');
  });

  it('rejects a branding lookup with no school_code', async () => {
    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/public/school/branding',
    });

    expect(res.statusCode).toBe(400);
    expect(res.json().title).toBe('BAD_REQUEST');
  });

  it('does not leak DPS branding for an unknown school_code', async () => {
    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/public/school/branding?school_code=NOT-A-SCHOOL',
    });

    expect(res.statusCode).toBe(404);
    expect(res.json().title).toBe('NOT_FOUND');
  });

  it('POST /api/v1/auth/session issues student JWT and includes school context', async () => {
    const res = await app.inject({
      method: 'POST',
      url: '/api/v1/auth/session',
      payload: {
        school_code: 'DPS-RKP-042',
        identifier: 'STD-104',
        credential: 'password',
      },
    });

    expect(res.statusCode).toBe(200);
    const body = JSON.parse(res.body);
    expect(body.access_token).toBeDefined();
    expect(body.user.role).toBe('student');
    expect(body.user.school_id).toBe('sch_dps_rkp');
    expect(body.school.school_name).toBe('Delhi Public School, R.K. Puram');
  });

  it('POST /api/v1/sync/events rejects unauthenticated callers', async () => {
    const res = await app.inject({
      method: 'POST',
      url: '/api/v1/sync/events',
      payload: { events: [{ id: 'evt-uuid-1', event_type: 'answer', payload: {} }] },
    });

    expect(res.statusCode).toBe(401);
  });

  it('POST /api/v1/sync/events processes offline outbox events for an authenticated student', async () => {
    const res = await app.inject({
      method: 'POST',
      url: '/api/v1/sync/events',
      headers: { authorization: `Bearer ${studentToken()}` },
      payload: {
        events: [
          {
            id: 'evt-uuid-1',
            event_type: 'learning.answer_submitted',
            payload: { is_correct: true },
          },
        ],
      },
    });

    expect(res.statusCode).toBe(200);
    const body = JSON.parse(res.body);
    expect(body.synced_count).toBe(1);
    expect(body.synced_ids).toContain('evt-uuid-1');
  });

  it('POST /api/v1/sync/events rejects a body without an events array', async () => {
    const res = await app.inject({
      method: 'POST',
      url: '/api/v1/sync/events',
      headers: { authorization: `Bearer ${studentToken()}` },
      payload: { events: 'not-an-array' },
    });

    expect(res.statusCode).toBe(400);
    expect(res.json().title).toBe('BAD_REQUEST');
  });

  it('POST /api/v1/learning/sessions/:id/answers rejects unauthenticated callers', async () => {
    const res = await app.inject({
      method: 'POST',
      url: '/api/v1/learning/sessions/sess-1/answers',
      payload: { question_id: 'q4', numeric_input: 25 },
    });

    expect(res.statusCode).toBe(401);
  });
});
