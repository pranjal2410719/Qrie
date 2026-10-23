import { describe, it, expect } from 'vitest';
import { buildApp } from '../src/app.js';

describe('HTTP error mapping', () => {
  const app = buildApp();

  it('returns 400 (not 500) for malformed JSON bodies', async () => {
    const res = await app.inject({
      method: 'POST',
      url: '/api/v1/sync/events',
      headers: { 'content-type': 'application/json' },
      payload: '{not-json',
    });

    expect(res.statusCode).toBe(400);
    const body = res.json();
    expect(body.status).toBe(400);
    expect(body.title).toBe('FST_ERR_CTP_INVALID_JSON_BODY');
    expect(body.requestId).toBeDefined();
  });

  it('returns 404 (not 500) for unknown routes', async () => {
    const res = await app.inject({
      method: 'GET',
      url: '/definitely-not-a-route',
    });

    expect(res.statusCode).toBe(404);
    expect(res.json().status).toBe(404);
    expect(res.json().requestId).toBeDefined();
  });

  it('returns 422 (not 500) for a Zod-validated body', async () => {
    const adminToken = app.jwt.sign({
      id: 'usr_admin_01',
      email: 'admin@school.edu',
      role: 'school_admin',
      schoolId: 'sch_dps_rkp',
    });

    const res = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/classes',
      headers: { authorization: `Bearer ${adminToken}` },
      payload: { grade: 99, section: 'Z' },
    });

    expect(res.statusCode).toBe(422);
    const body = res.json();
    expect(body.title).toBe('VALIDATION_ERROR');
    expect(body.details).toEqual(
      expect.arrayContaining([expect.objectContaining({ path: 'grade' })]),
    );
  });
});
