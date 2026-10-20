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

  it('POST /api/v1/sync/events processes offline outbox events', async () => {
    const res = await app.inject({
      method: 'POST',
      url: '/api/v1/sync/events',
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
});
