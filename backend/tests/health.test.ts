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

  it('GET /health/status returns operational diagnostic metrics', async () => {
    vi.spyOn(Database, 'healthCheck').mockResolvedValue(true);
    vi.spyOn(Database, 'query').mockResolvedValue({
      rows: [
        { relay_status: 'pending', count: '5' },
        { relay_status: 'relayed', count: '42' },
      ],
    } as any);

    const res = await app.inject({
      method: 'GET',
      url: '/health/status',
    });

    expect(res.statusCode).toBe(200);
    const body = res.json();
    expect(body.service).toBe('Qrie AI Application Backend');
    expect(body.status).toBe('ready');
    expect(body.database).toBe('connected');
    expect(body.outbox_backlog.pending).toBe(5);
    expect(body.outbox_backlog.relayed).toBe(42);
    expect(body.timestamp).toBeDefined();
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
