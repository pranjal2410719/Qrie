/**
 * Database integration tests – event payload preservation.
 *
 * INTEGRATION TESTS – REQUIRE A REACHABLE POSTGRESQL DATABASE.
 *
 * When no database is reachable, every test in this file is explicitly skipped
 * via Vitest's `test.skip()` so the summary clearly shows SKIPPED rather than
 * PASS or FAIL.
 *
 * To run these tests locally:
 *   1. Start PostgreSQL (Docker: `docker run -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres:15`)
 *   2. Apply the migration: `psql $DATABASE_URL -f supabase/migrations/0014_sync_event_outbox.sql`
 *   3. Set DATABASE_URL and run: `npm --prefix backend test`
 *
 * These tests must NOT be counted as passing unit tests when the database is
 * unavailable.  They are separated from pure unit tests intentionally.
 */
import { describe, it, expect, beforeAll } from 'vitest';
import { insertEvents, listPendingEvents } from '../src/modules/student/event-store.js';
import { Database } from '../src/database/index.js';
import type { NormalizedEvent } from '../src/modules/student/contracts.js';

// ---------------------------------------------------------------------------
// Database availability guard
// ---------------------------------------------------------------------------

let _dbAvailable: boolean | null = null;

async function isDbAvailable(): Promise<boolean> {
  if (_dbAvailable !== null) return _dbAvailable;
  try {
    await Database.query('SELECT 1', []);
    _dbAvailable = true;
  } catch {
    _dbAvailable = false;
  }
  return _dbAvailable;
}

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

const ORG_ID = 'test_org_persist';
const USER_ID = 'test_user_persist';

const flatEligibleEvent: NormalizedEvent = {
  eventId: 'evt_flat_eligible_1',
  sessionId: 'sess_1',
  eventType: 'attempt',
  occurredAt: '2026-10-24T00:00:00.000Z',
  payload: {},
  lamEvent: {
    event_id: 'evt_flat_eligible_1',
    student_id: USER_ID,
    session_id: 'sess_1',
    concept_ids: ['concept_1'],
    item_id: 'item_1',
    timestamp: '2026-10-24T00:00:00.000Z',
    event_type: 'attempt',
    correctness: true,
  },
  ineligibleReason: null,
};

const flatIneligibleEvent: NormalizedEvent = {
  eventId: 'evt_flat_ineligible_1',
  sessionId: null,
  eventType: 'learning.answer_submitted',
  occurredAt: null,
  payload: {
    concept_ids: ['concept_2'],
    item_id: 'item_2',
    correctness: false,
    extra_field: 'diagnostic_value',
  },
  lamEvent: null,
  ineligibleReason: 'MISSING_SESSION_ID',
};

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

describe('Event persistence integration – flat eligible event', () => {
  beforeAll(async () => {
    if (!(await isDbAvailable())) return;
    await Database.query(
      'DELETE FROM public.sync_event WHERE org_id = $1 AND event_id = ANY($2::text[])',
      [ORG_ID, [flatEligibleEvent.eventId, flatIneligibleEvent.eventId]],
    );
  });

  it('inserts a flat eligible event and returns its id', async (ctx) => {
    if (!(await isDbAvailable())) return ctx.skip();
    const inserted = await insertEvents(ORG_ID, USER_ID, [flatEligibleEvent]);
    expect(inserted).toContain(flatEligibleEvent.eventId);
  });

  it('flat eligible event: concept_ids survive the database round-trip', async (ctx) => {
    if (!(await isDbAvailable())) return ctx.skip();
    const pending = await listPendingEvents(ORG_ID, USER_ID, 10);
    const row = pending.find((r) => r.eventId === flatEligibleEvent.eventId);
    expect(row).toBeDefined();
    expect(row?.payload.concept_ids).toEqual(['concept_1']);
  });

  it('flat eligible event: item_id survives the database round-trip', async (ctx) => {
    if (!(await isDbAvailable())) return ctx.skip();
    const pending = await listPendingEvents(ORG_ID, USER_ID, 10);
    const row = pending.find((r) => r.eventId === flatEligibleEvent.eventId);
    expect(row?.payload.item_id).toBe('item_1');
  });

  it('flat eligible event: correctness survives the database round-trip', async (ctx) => {
    if (!(await isDbAvailable())) return ctx.skip();
    const pending = await listPendingEvents(ORG_ID, USER_ID, 10);
    const row = pending.find((r) => r.eventId === flatEligibleEvent.eventId);
    expect(row?.payload.correctness).toBe(true);
  });

  it('duplicate insert of the same event_id is ignored (idempotency)', async (ctx) => {
    if (!(await isDbAvailable())) return ctx.skip();
    const second = await insertEvents(ORG_ID, USER_ID, [flatEligibleEvent]);
    expect(second).toHaveLength(0);
  });
});

describe('Event persistence integration – flat ineligible event', () => {
  it('inserts an ineligible event and returns its id', async (ctx) => {
    if (!(await isDbAvailable())) return ctx.skip();
    const inserted = await insertEvents(ORG_ID, USER_ID, [flatIneligibleEvent]);
    expect(inserted).toContain(flatIneligibleEvent.eventId);
  });

  it('ineligible event: concept_ids from payload survive the round-trip', async (ctx) => {
    if (!(await isDbAvailable())) return ctx.skip();
    const pending = await listPendingEvents(ORG_ID, USER_ID, 10);
    const row = pending.find((r) => r.eventId === flatIneligibleEvent.eventId);
    expect(row).toBeDefined();
    expect(row?.payload.concept_ids).toEqual(['concept_2']);
  });

  it('ineligible event: item_id from payload survives the round-trip', async (ctx) => {
    if (!(await isDbAvailable())) return ctx.skip();
    const pending = await listPendingEvents(ORG_ID, USER_ID, 10);
    const row = pending.find((r) => r.eventId === flatIneligibleEvent.eventId);
    expect(row?.payload.item_id).toBe('item_2');
  });

  it('ineligible event: correctness from payload survives the round-trip', async (ctx) => {
    if (!(await isDbAvailable())) return ctx.skip();
    const pending = await listPendingEvents(ORG_ID, USER_ID, 10);
    const row = pending.find((r) => r.eventId === flatIneligibleEvent.eventId);
    expect(row?.payload.correctness).toBe(false);
  });

  it('ineligible event: _ineligible_reason is stored', async (ctx) => {
    if (!(await isDbAvailable())) return ctx.skip();
    const pending = await listPendingEvents(ORG_ID, USER_ID, 10);
    const row = pending.find((r) => r.eventId === flatIneligibleEvent.eventId);
    expect(row?.payload._ineligible_reason).toBe('MISSING_SESSION_ID');
  });

  it('ineligible event: extra payload fields survive the round-trip', async (ctx) => {
    if (!(await isDbAvailable())) return ctx.skip();
    const pending = await listPendingEvents(ORG_ID, USER_ID, 10);
    const row = pending.find((r) => r.eventId === flatIneligibleEvent.eventId);
    expect(row?.payload.extra_field).toBe('diagnostic_value');
  });
});
