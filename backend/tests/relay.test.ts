import { describe, it, expect, vi, beforeEach } from 'vitest';

vi.mock('../src/modules/student/event-store.js', () => ({
  listPendingEvents: vi.fn(),
  claimPendingEvents: vi.fn(),
  markRelayed: vi.fn(),
  markSkipped: vi.fn(),
  markFailed: vi.fn(),
}));

import * as store from '../src/modules/student/event-store.js';
import { relayPendingEvents } from '../src/modules/student/relay.js';

const claimPending = vi.mocked(store.claimPendingEvents);
const listPending = vi.mocked(store.listPendingEvents);
const markRelayed = vi.mocked(store.markRelayed);
const markSkipped = vi.mocked(store.markSkipped);
const markFailed = vi.mocked(store.markFailed);

function pendingRow(overrides: Record<string, unknown> = {}) {
  return {
    eventId: 'evt_1',
    sessionId: 'sess_1',
    eventType: 'learning.answer_submitted',
    occurredAt: '2026-10-23T10:00:00.000Z',
    payload: { question_id: 'q4', concept_ids: ['c1'], is_correct: true },
    ...overrides,
  };
}

describe('LAM relay drain', () => {
  beforeEach(() => {
    vi.clearAllMocks();
    claimPending.mockResolvedValue([]);
    listPending.mockResolvedValue([]);
    markRelayed.mockResolvedValue();
    markSkipped.mockResolvedValue();
    markFailed.mockResolvedValue();
  });

  it('relays an eligible event and marks it relayed', async () => {
    claimPending.mockResolvedValue([pendingRow()]);
    const forwardEvent = vi.fn().mockResolvedValue({ status: 'ingested', event_id: 'evt_1' });

    const summary = await relayPendingEvents('sch_1', 'std_1', { forwardEvent });

    expect(forwardEvent).toHaveBeenCalledWith(
      'sch_1',
      expect.objectContaining({
        event_id: 'evt_1',
        student_id: 'std_1',
        session_id: 'sess_1',
        concept_ids: ['c1'],
        event_type: 'attempt',
        correctness: true,
      }),
    );
    expect(markRelayed).toHaveBeenCalledWith('sch_1', ['evt_1']);
    expect(summary).toEqual({ attempted: 1, relayed: 1, skipped: 0, failed: 0 });
  });

  it('skips an ineligible event without calling LAM', async () => {
    claimPending.mockResolvedValue([
      pendingRow({ payload: { question_id: 'q4', is_correct: true } }),
    ]);
    const forwardEvent = vi.fn();

    const summary = await relayPendingEvents('sch_1', 'std_1', { forwardEvent });

    expect(forwardEvent).not.toHaveBeenCalled();
    expect(markSkipped).toHaveBeenCalledWith('sch_1', 'evt_1', 'MISSING_CONCEPT_IDS');
    expect(summary).toEqual({ attempted: 1, relayed: 0, skipped: 1, failed: 0 });
  });

  it('keeps the event retryable when LAM is unreachable', async () => {
    claimPending.mockResolvedValue([pendingRow()]);
    const forwardEvent = vi.fn().mockResolvedValue({ status: 'relay_queued', event_id: 'evt_1' });

    const summary = await relayPendingEvents('sch_1', 'std_1', { forwardEvent });

    expect(markRelayed).not.toHaveBeenCalled();
    expect(markFailed).toHaveBeenCalledWith('sch_1', 'evt_1', 'LAM_UNREACHABLE');
    expect(summary).toEqual({ attempted: 1, relayed: 0, skipped: 0, failed: 1 });
  });

  it('records a transport exception instead of throwing', async () => {
    claimPending.mockResolvedValue([pendingRow()]);
    const forwardEvent = vi.fn().mockRejectedValue(new Error('socket hang up'));

    const summary = await relayPendingEvents('sch_1', 'std_1', { forwardEvent });

    expect(markFailed).toHaveBeenCalledWith('sch_1', 'evt_1', 'socket hang up');
    expect(summary.failed).toBe(1);
  });

  it('scopes the drain to the authenticated org and user', async () => {
    const forwardEvent = vi.fn().mockResolvedValue({ status: 'ingested', event_id: 'evt_1' });
    await relayPendingEvents('sch_other', 'std_other', { forwardEvent }, 7);

    expect(claimPending).toHaveBeenCalledWith('sch_other', 'std_other', 7);
  });

  it('does nothing for an empty queue', async () => {
    const forwardEvent = vi.fn();
    const summary = await relayPendingEvents('sch_1', 'std_1', { forwardEvent });

    expect(forwardEvent).not.toHaveBeenCalled();
    expect(summary).toEqual({ attempted: 0, relayed: 0, skipped: 0, failed: 0 });
  });
});
