import { beforeEach, describe, expect, it, vi } from 'vitest';

vi.mock('../src/database/index.js', () => ({
  Database: {
    query: vi.fn(),
  },
}));

import { Database } from '../src/database/index.js';
import { insertEvents, listSkippedEventsForReplay, requeueSkippedEvents } from '../src/modules/student/event-store.js';

const query = vi.mocked(Database.query);

describe('sync event store', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('persists normalized payload metadata for relay re-evaluation', async () => {
    query.mockResolvedValueOnce({ rows: [{ event_id: 'evt_1' }] } as any);

    const inserted = await insertEvents('sch_1', 'std_1', [
      {
        eventId: 'evt_1',
        sessionId: 'sess_1',
        eventType: 'attempt',
        occurredAt: '2026-10-23T10:00:00.000Z',
        payload: { question_id: 'q1' },
        lamEvent: {
          event_id: 'evt_1',
          student_id: 'std_1',
          session_id: 'sess_1',
          concept_ids: ['c1'],
          item_id: 'q1',
          timestamp: '2026-10-23T10:00:00.000Z',
          event_type: 'attempt',
          correctness: true,
        },
        ineligibleReason: null,
      },
    ]);

    expect(inserted).toEqual(['evt_1']);
    const [, params] = query.mock.calls[0];
    const serialized = params?.[5] as string;
    expect(JSON.parse(serialized)).toMatchObject({
      question_id: 'q1',
      lamEvent: { correctness: true, event_type: 'attempt' },
      ineligibleReason: null,
    });
  });

  it('requeues only skipped rows and preserves idempotency', async () => {
    query.mockResolvedValueOnce({ rows: [{ event_id: 'evt_1' }] } as any);

    const replayed = await requeueSkippedEvents('sch_1', ['evt_1', 'evt_2'], 'TICKET-42');

    expect(replayed).toEqual(['evt_1']);
    expect(query).toHaveBeenCalledWith(
      expect.stringContaining("and relay_status = 'skipped'"),
      expect.arrayContaining(['sch_1', ['evt_1', 'evt_2']]),
    );
  });

  it('supports dry-run listing for replay with stable ordering', async () => {
    query.mockResolvedValueOnce({
      rows: [
        {
          event_id: 'evt_1',
          session_id: 'sess_1',
          event_type: 'attempt',
          occurred_at: '2026-10-23T10:00:00.000Z',
          payload: { lamEvent: { correctness: true } },
          relay_attempts: 2,
          last_error: 'MISSING_CORRECTNESS',
        },
      ],
    } as any);

    const rows = await listSkippedEventsForReplay('sch_1', null, 10);

    expect(rows).toEqual([
      {
        eventId: 'evt_1',
        eventType: 'attempt',
        sessionId: 'sess_1',
        occurredAt: '2026-10-23T10:00:00.000Z',
        payload: { lamEvent: { correctness: true } },
        relayAttempts: 2,
        lastError: 'MISSING_CORRECTNESS',
      },
    ]);
  });
});
