/**
 * Pure unit tests for buildStoredPayload.
 *
 * These tests do NOT require a database connection.  They exercise the payload-
 * construction logic in isolation from the persistence layer so the fix can be
 * verified immediately without provisioning PostgreSQL.
 *
 * Database-round-trip verification lives in event_persistence.test.ts and
 * event_store_regression.test.ts; those are marked as integration tests and
 * skipped automatically when no database is reachable.
 */
import { describe, it, expect } from 'vitest';
import { buildStoredPayload } from '../src/modules/student/event-store.js';
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

describe('buildStoredPayload – eligible events', () => {
  it('stores the lamEvent object directly', () => {
    const event = makeEligibleEvent();
    const result = buildStoredPayload(event);
    expect(result).toEqual(event.lamEvent);
  });

  it('includes concept_ids, item_id, and correctness from lamEvent', () => {
    const event = makeEligibleEvent();
    const result = buildStoredPayload(event);
    expect(result.concept_ids).toEqual(['c1', 'c2']);
    expect(result.item_id).toBe('itm_1');
    expect(result.correctness).toBe(true);
  });

  it('does NOT use the raw payload when lamEvent is present', () => {
    const event = makeEligibleEvent({
      payload: { unrelated: 'field' },
    });
    const result = buildStoredPayload(event);
    expect(result).not.toHaveProperty('unrelated');
  });
});

describe('buildStoredPayload – ineligible events (lamEvent is null)', () => {
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

  it('preserves arbitrary payload fields (data minimisation: keep what was sent)', () => {
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
    // Edge-case: an ineligible event that somehow has no reason set.
    const event = makeIneligibleEvent({ ineligibleReason: null });
    const result = buildStoredPayload(event);
    expect(result).not.toHaveProperty('_ineligible_reason');
  });
});
