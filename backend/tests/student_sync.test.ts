import { describe, it, expect, vi, beforeAll, afterAll, beforeEach } from 'vitest';
import type { FastifyInstance } from 'fastify';

vi.mock('../src/modules/student/event-store.js', () => ({
  insertEvents: vi.fn(),
  listPendingEvents: vi.fn(),
  markRelayed: vi.fn(),
  markSkipped: vi.fn(),
  markFailed: vi.fn(),
}));

vi.mock('../src/modules/student/relay.js', () => ({
  relayPendingEvents: vi.fn(),
}));

import { buildApp } from '../src/app.js';
import * as store from '../src/modules/student/event-store.js';
import * as relay from '../src/modules/student/relay.js';

const insertEvents = vi.mocked(store.insertEvents);
const relayPendingEvents = vi.mocked(relay.relayPendingEvents);

const EMPTY_RELAY = { attempted: 0, relayed: 0, skipped: 0, failed: 0 };

function canonicalEvent(id = 'evt_1') {
  return {
    id,
    event_type: 'attempt',
    session_id: 'sess_1',
    concept_ids: ['c1'],
    item_id: 'i1',
    timestamp: '2026-10-23T10:00:00.000Z',
    correctness: true,
  };
}

describe('POST /api/v1/sync/events', () => {
  let app: FastifyInstance;

  beforeAll(async () => {
    app = buildApp();
    await app.ready();
  });

  afterAll(async () => {
    await app.close();
  });

  beforeEach(() => {
    vi.clearAllMocks();
    insertEvents.mockResolvedValue([]);
    relayPendingEvents.mockResolvedValue(EMPTY_RELAY);
  });

  const token = (overrides: Record<string, unknown> = {}) =>
    app.jwt.sign({
      id: 'std_01',
      email: 'student@school.edu',
      role: 'student',
      schoolId: 'sch_dps_rkp',
      ...overrides,
    });

  const post = (payload: unknown, bearer?: string) =>
    app.inject({
      method: 'POST',
      url: '/api/v1/sync/events',
      headers: bearer ? { authorization: `Bearer ${bearer}` } : {},
      payload: payload as any,
    });

  it('rejects unauthenticated callers', async () => {
    const res = await post({ events: [canonicalEvent()] });

    expect(res.statusCode).toBe(401);
    expect(insertEvents).not.toHaveBeenCalled();
  });

  it('rejects a body without an events array', async () => {
    const res = await post({ events: 'not-an-array' }, token());

    expect(res.statusCode).toBe(400);
    expect(res.json().title).toBe('BAD_REQUEST');
  });

  it('rejects a batch larger than the 20-event limit', async () => {
    const events = Array.from({ length: 21 }, (_, index) => canonicalEvent(`evt_${index}`));
    const res = await post({ events }, token());

    expect(res.statusCode).toBe(400);
    expect(insertEvents).not.toHaveBeenCalled();
  });

  it('persists events under the JWT identity and ignores a body student_id', async () => {
    insertEvents.mockResolvedValue(['evt_1']);
    relayPendingEvents.mockResolvedValue({ attempted: 1, relayed: 1, skipped: 0, failed: 0 });

    const res = await post(
      {
        student_id: 'std_attacker',
        events: [canonicalEvent('evt_1'), { ...canonicalEvent('evt_2'), correctness: false }],
      },
      token(),
    );

    expect(res.statusCode).toBe(200);
    const [orgId, userId, normalized] = insertEvents.mock.calls[0];
    expect(orgId).toBe('sch_dps_rkp');
    expect(userId).toBe('std_01');
    expect(normalized).toHaveLength(2);
    expect(normalized[0].lamEvent?.student_id).toBe('std_01');

    const body = res.json();
    expect(body.synced_count).toBe(2);
    expect(body.synced_ids).toEqual(['evt_1', 'evt_2']);
    expect(body.duplicates).toBe(1);
    expect(body.relay).toMatchObject({ enabled: true, relayed: 1 });
  });

  it('acknowledges a replay without inserting twice', async () => {
    insertEvents.mockResolvedValue([]);

    const res = await post({ events: [canonicalEvent('evt_1')] }, token());

    expect(res.statusCode).toBe(200);
    expect(res.json().duplicates).toBe(1);
    expect(res.json().synced_ids).toEqual(['evt_1']);
  });

  it('collapses a repeated id inside one batch', async () => {
    const res = await post(
      { events: [canonicalEvent('evt_1'), canonicalEvent('evt_1')] },
      token(),
    );

    expect(res.statusCode).toBe(200);
    expect(insertEvents.mock.calls[0][2]).toHaveLength(1);
    expect(res.json().synced_count).toBe(1);
  });

  it('returns 503 when the event store is unavailable', async () => {
    insertEvents.mockRejectedValue(new Error('connect ECONNREFUSED'));

    const res = await post({ events: [canonicalEvent()] }, token());

    expect(res.statusCode).toBe(503);
    expect(res.json().title).toBe('SYNC_STORE_UNAVAILABLE');
    expect(res.json().detail).not.toContain('ECONNREFUSED');
  });

  it('acknowledges a stored batch when the relay drain fails', async () => {
    insertEvents.mockResolvedValue(['evt_1']);
    relayPendingEvents.mockRejectedValue(new Error('queue unavailable'));

    const res = await post({ events: [canonicalEvent()] }, token());

    expect(res.statusCode).toBe(200);
    expect(res.json().relay).toMatchObject({ enabled: true, deferred: true });
  });

  it('accepts an empty batch without touching the store', async () => {
    const res = await post({ events: [] }, token());

    expect(res.statusCode).toBe(200);
    expect(res.json().synced_count).toBe(0);
    expect(insertEvents).not.toHaveBeenCalled();
  });
});
