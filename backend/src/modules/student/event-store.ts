import { Database } from '../../database/index.js';
import type { NormalizedEvent } from './contracts.js';

/**
 * Persistence for the mobile outbox handoff (`public.sync_event`).
 *
 * The primary key is `(org_id, event_id)`, so `on conflict do nothing` is the
 * idempotency guarantee: a replayed batch does not insert twice and does not
 * produce a second relay. That property is enforced by the database, not by a
 * read-then-write in application code.
 */

export const MAX_RELAY_ATTEMPTS = 10;

export interface PendingEventRow {
  eventId: string;
  sessionId: string | null;
  eventType: string;
  occurredAt: string | null;
  payload: Record<string, any>;
}

interface InsertedRow {
  event_id: string;
}

interface PendingRow {
  event_id: string;
  session_id: string | null;
  event_type: string;
  occurred_at: Date | string | null;
  payload: Record<string, any>;
}

/**
 * Determine what JSON to persist in the `payload` column.
 *
 * Priority:
 *  1. If the event was eligible, `lamEvent` holds all normalised fields —
 *     store that so the relay can forward it without re-normalising.
 *  2. If the event is ineligible (`lamEvent` is null), fall back to the
 *     original `event.payload` merged with any top-level fields that were
 *     extracted during normalisation (sessionId, eventType, occurredAt).
 *     This preserves diagnostic context (concept_ids, item_id, correctness,
 *     etc.) that the caller may have sent at the top level rather than
 *     inside the payload envelope, ensuring ineligible events are not
 *     silently stripped of the information needed to diagnose why they were
 *     rejected.
 *
 * Data minimisation: we do not duplicate the entire incoming request;
 * we store only the fields that were actually resolved during normalisation.
 */
export function buildStoredPayload(event: NormalizedEvent): Record<string, any> {
  if (event.lamEvent !== null) {
    return event.lamEvent;
  }

  // Ineligible path: merge the original payload with the top-level fields
  // that normaliseEvent resolved from the flat event shape so nothing is lost.
  return {
    ...event.payload,
    // Add resolved scalar fields only when they are non-null; avoids
    // polluting the stored document with explicit nulls.
    ...(event.sessionId !== null ? { session_id: event.sessionId } : {}),
    ...(event.occurredAt !== null ? { timestamp: event.occurredAt } : {}),
    // ineligibleReason is diagnostic metadata — useful for debugging.
    ...(event.ineligibleReason !== null ? { _ineligible_reason: event.ineligibleReason } : {}),
  };
}

/**
 * Inserts a batch, ignoring ids that already exist for this tenant.
 * Returns only the ids that were newly inserted.
 */
export async function insertEvents(
  orgId: string,
  userId: string,
  events: NormalizedEvent[],
): Promise<string[]> {
  if (events.length === 0) return [];

  const params: unknown[] = [];
  const placeholders = events.map((event, index) => {
    const base = index * 7;
    params.push(
      orgId,
      userId,
      event.eventId,
      event.sessionId,
      event.eventType,
      JSON.stringify(buildStoredPayload(event)),
      event.occurredAt,
    );
    return `($${base + 1}, $${base + 2}, $${base + 3}, $${base + 4}, $${base + 5}, $${base + 6}::jsonb, $${base + 7})`;
  });

  const result = await Database.query<InsertedRow>(
    `insert into public.sync_event
       (org_id, user_id, event_id, session_id, event_type, payload, occurred_at)
     values ${placeholders.join(', ')}
     on conflict (org_id, event_id) do nothing
     returning event_id`,
    params,
  );

  return result.rows.map((row) => row.event_id);
}

/**
 * Retryable rows for one student, oldest first. Scoped by org AND user so one
 * student's queue can never drain another's.
 */
export async function listPendingEvents(
  orgId: string,
  userId: string,
  limit: number,
): Promise<PendingEventRow[]> {
  const bounded = Math.max(1, Math.min(100, Math.trunc(limit)));
  const result = await Database.query<PendingRow>(
    `select event_id, session_id, event_type, occurred_at, payload
       from public.sync_event
      where org_id = $1
        and user_id = $2
        and relay_status = 'pending'
        and relay_attempts < $3
      order by received_at asc
      limit $4`,
    [orgId, userId, MAX_RELAY_ATTEMPTS, bounded],
  );

  return result.rows.map((row) => ({
    eventId: row.event_id,
    sessionId: row.session_id,
    eventType: row.event_type,
    occurredAt: row.occurred_at ? new Date(row.occurred_at).toISOString() : null,
    payload: row.payload ?? {},
  }));
}

export async function markRelayed(orgId: string, eventIds: string[]): Promise<void> {
  if (eventIds.length === 0) return;
  await Database.query(
    `update public.sync_event
        set relay_status = 'relayed',
            relayed_at = now(),
            last_error = null
      where org_id = $1
        and event_id = any($2::text[])`,
    [orgId, eventIds],
  );
}

export async function markSkipped(
  orgId: string,
  eventId: string,
  reason: string,
): Promise<void> {
  await Database.query(
    `update public.sync_event
        set relay_status = 'skipped',
            last_error = $3
      where org_id = $1
        and event_id = $2`,
    [orgId, eventId, reason],
  );
}

/**
 * Records a failed attempt. The row stays `pending` until the retry budget is
 * exhausted, at which point it becomes terminal `failed` and is surfaced in the
 * sync response instead of retrying forever.
 */
export async function markFailed(
  orgId: string,
  eventId: string,
  reason: string,
): Promise<void> {
  await Database.query(
    `update public.sync_event
        set relay_attempts = relay_attempts + 1,
            last_error = $3,
            relay_status = case
              when relay_attempts + 1 >= $4 then 'failed'
              else 'pending'
            end
      where org_id = $1
        and event_id = $2`,
    [orgId, eventId, reason, MAX_RELAY_ATTEMPTS],
  );
}
