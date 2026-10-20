import { describe, it, expect, vi, beforeEach } from 'vitest';
import { buildApp } from '../src/app.js';
import { Database } from '../src/database/index.js';

describe('Health and Diagnostic Probes', () => {
  const app = buildApp();

  beforeEach(() => {
    vi.restoreAllMocks();
  });

  it('GET /health/live returns HTTP 200 with alive status', async () => {
    const res = await app.inject({
      method: 'GET',
      url: '/health/live',
    });

    expect(res.statusCode).toBe(200);
    expect(res.json()).toEqual({ status: 'alive' });
    expect(res.headers['x-request-id']).toBeDefined();
  });

  it('GET /health/ready returns HTTP 200 when database is healthy', async () => {
    vi.spyOn(Database, 'healthCheck').mockResolvedValue(true);

    const res = await app.inject({
      method: 'GET',
      url: '/health/ready',
    });

    expect(res.statusCode).toBe(200);
    expect(res.json()).toEqual({ status: 'ready', database: 'connected' });
  });

  it('GET /health/ready returns HTTP 503 when database is disconnected', async () => {
    vi.spyOn(Database, 'healthCheck').mockResolvedValue(false);

    const res = await app.inject({
      method: 'GET',
      url: '/health/ready',
    });

    expect(res.statusCode).toBe(503);
    expect(res.json()).toEqual({ status: 'unavailable', database: 'disconnected' });
  });

  it('GET / returns root service information', async () => {
    const res = await app.inject({
      method: 'GET',
      url: '/',
    });

    expect(res.statusCode).toBe(200);
    const body = res.json();
    expect(body.service).toBe('Qrie AI Application Backend');
    expect(body.status).toBe('healthy');
  });
});
