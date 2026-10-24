// Integration test for event persistence ensuring flat event fields are retained
import { expect, test, describe } from 'vitest';
import { insertEvents, listPendingEvents } from '../src/modules/student/event-store.js';
import { Database } from '../src/database/index.js';
import type { NormalizedEvent } from '../src/modules/student/contracts.js';

/**
 * Helper to check if real database is reachable.
 */
async function dbAvailable(): Promise<boolean> {
  try {
    await Database.query<{ now: string }>('SELECT now()', []);
    return true;
  } catch {
    return false;
  }
}

describe('Event persistence integration', async () => {
  const orgId = 'test_org';
  const userId = 'test_user';
  const flatEvent: NormalizedEvent = {
    eventId: 'evt_flat_1',
    sessionId: 'sess_1',
    eventType: 'attempt',
    occurredAt: new Date().toISOString(),
    payload: {},
    lamEvent: {
      event_id: 'evt_flat_1',
      student_id: userId,
      session_id: 'sess_1',
      concept_ids: ['concept_1'],
      item_id: 'item_1',
      timestamp: new Date().toISOString(),
      event_type: 'attempt',
      correctness: true,
    },
    ineligibleReason: null,
  };

  test('skip if DB not available', async () => {
    const available = await dbAvailable();
    expect(available).toBe(true);
  });

  test('flat event fields survive persistence', async () => {
    if (!(await dbAvailable())) return test.skip();
    // Clean any prior rows for idempotency
    await Database.query('DELETE FROM public.sync_event WHERE org_id = $1 AND event_id = $2', [orgId, flatEvent.eventId]);
    const inserted = await insertEvents(orgId, userId, [flatEvent]);
    expect(inserted).toContain(flatEvent.eventId);
    const pending = await listPendingEvents(orgId, userId, 10);
    const row = pending.find((r) => r.eventId === flatEvent.eventId);
    expect(row).toBeDefined();
    // payload stored should be the lamEvent JSON we provided
    expect(row?.payload).toMatchObject({
      event_id: flatEvent.eventId,
      student_id: userId,
      session_id: flatEvent.sessionId,
      concept_ids: ['concept_1'],
      item_id: 'item_1',
      correctness: true,
    });
  });
});
