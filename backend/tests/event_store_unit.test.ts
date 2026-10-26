/**
 * Pure unit tests for event-store logic.
 *
 * Exercises payload construction, claim queries, and relay recovery logic
 * without requiring an active database connection.
 */
import { describe, it, expect, vi, beforeEach } from 'vitest';
import {
  buildStoredPayload,
  claimPendingEvents,
  markRelayed,
  markSkipped,
  markFailed,
} from '../src/modules/student/event-store.js';
import { Database } from '../src/database/index.js';
import type { NormalizedEvent } from '../src/modules/student/contracts.js';

function makeEligibleEvent(overrides: Partial<NormalizedEvent> = {}): NormalizedEvent {
  return {
    eventId: 'evt_eligible',
    sessionId: 'sess_1',
    eventType: 'attempt',
    occurredAt: '2026-10-24T00:00:00.000Z',
    payload: {},
    lamEvent: {
      event_id: 'evt_eligible',
      student_id: 'std_1',
      session_id: 'sess_1',
      concept_ids: ['c1', 'c2'],
      item_id: 'itm_1',
      timestamp: '2026-10-24T00:00:00.000Z',
      event_type: 'attempt',
      correctness: true,
    },
    ineligibleReason: null,
    ...overrides,
  };
}

function makeIneligibleEvent(overrides: Partial<NormalizedEvent> = {}): NormalizedEvent {
  return {
    eventId: 'evt_ineligible',
    sessionId: null,
    eventType: 'learning.answer_submitted',
    occurredAt: null,
    payload: {
      concept_ids: ['c3'],
      item_id: 'itm_2',
      correctness: false,
      arbitrary_field: 'keep_me',
    },
    lamEvent: null,
    ineligibleReason: 'MISSING_SESSION_ID',
    ...overrides,
  };
}

describe('buildStoredPayload – eligible event', () => {
  it('stores lamEvent directly when eligible', () => {
    const event = makeEligibleEvent();
    const result = buildStoredPayload(event);
    expect(result).toBe(event.lamEvent);
  });
});

describe('buildStoredPayload – ineligible event', () => {
  it('preserves concept_ids from the original payload', () => {
    const event = makeIneligibleEvent();
    const result = buildStoredPayload(event);
    expect(result.concept_ids).toEqual(['c3']);
  });

  it('preserves item_id from the original payload', () => {
    const event = makeIneligibleEvent();
    const result = buildStoredPayload(event);
    expect(result.item_id).toBe('itm_2');
  });

  it('preserves correctness from the original payload', () => {
    const event = makeIneligibleEvent();
    const result = buildStoredPayload(event);
    expect(result.correctness).toBe(false);
  });

  it('preserves arbitrary payload fields', () => {
    const event = makeIneligibleEvent();
    const result = buildStoredPayload(event);
    expect(result.arbitrary_field).toBe('keep_me');
  });

  it('includes the ineligible reason as _ineligible_reason', () => {
    const event = makeIneligibleEvent();
    const result = buildStoredPayload(event);
    expect(result._ineligible_reason).toBe('MISSING_SESSION_ID');
  });

  it('merges a resolved sessionId when present', () => {
    const event = makeIneligibleEvent({
      sessionId: 'sess_resolved',
      ineligibleReason: 'MISSING_CONCEPT_IDS',
    });
    const result = buildStoredPayload(event);
    expect(result.session_id).toBe('sess_resolved');
  });

  it('merges a resolved occurredAt timestamp when present', () => {
    const event = makeIneligibleEvent({
      occurredAt: '2026-10-24T08:00:00.000Z',
    });
    const result = buildStoredPayload(event);
    expect(result.timestamp).toBe('2026-10-24T08:00:00.000Z');
  });

  it('does not add session_id key when sessionId is null', () => {
    const event = makeIneligibleEvent({ sessionId: null });
    const result = buildStoredPayload(event);
    expect(result).not.toHaveProperty('session_id');
  });

  it('does not add timestamp key when occurredAt is null', () => {
    const event = makeIneligibleEvent({ occurredAt: null });
    const result = buildStoredPayload(event);
    expect(result).not.toHaveProperty('timestamp');
  });

  it('does not add _ineligible_reason when ineligibleReason is null', () => {
    const event = makeIneligibleEvent({ ineligibleReason: null });
    const result = buildStoredPayload(event);
    expect(result).not.toHaveProperty('_ineligible_reason');
  });
});

describe('claimPendingEvents recovery and query safety', () => {
  beforeEach(() => {
    vi.restoreAllMocks();
  });

  it('updates claimed_at to now() and only reclaims processing events after 60s of claim', async () => {
    let capturedSql = '';
    vi.spyOn(Database, 'query').mockImplementation(async (sql: string) => {
      capturedSql = sql;
      return { rows: [] } as any;
    });

    await claimPendingEvents('sch_1', 'std_1', 10);

    expect(capturedSql).toContain('claimed_at = now()');
    expect(capturedSql).toContain("claimed_at is null or claimed_at < now() - interval '60 seconds'");
    expect(capturedSql).not.toContain("received_at < now() - interval '60 seconds'");
  });

  it('resets claimed_at to null on terminal status updates (relayed, skipped, failed)', async () => {
    let lastSql = '';
    vi.spyOn(Database, 'query').mockImplementation(async (sql: string) => {
      lastSql = sql;
      return { rows: [] } as any;
    });

    await markRelayed('sch_1', ['evt_1']);
    expect(lastSql).toContain("relay_status = 'relayed'");
    expect(lastSql).toContain('claimed_at = null');

    await markSkipped('sch_1', 'evt_1', 'INELIGIBLE');
    expect(lastSql).toContain("relay_status = 'skipped'");
    expect(lastSql).toContain('claimed_at = null');

    await markFailed('sch_1', 'evt_1', 'NETWORK_TIMEOUT');
    expect(lastSql).toContain('claimed_at = null');
  });
});
