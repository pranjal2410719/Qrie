import { LamAdapterClient } from '../lam-integration/client.js';
import type { LamEventPayload } from '../lam-integration/client.js';
import { normalizeEvent } from './contracts.js';
import { listPendingEvents, markFailed, markRelayed, markSkipped } from './event-store.js';

/**
 * Best-effort forwarding of persisted events to LAM.
 *
 * Persistence already happened before this runs, so a LAM outage must not fail
 * the client's sync. Failures stay `pending` and are retried on a later sync;
 * ineligible events become terminal `skipped` immediately because retrying them
 * can never succeed.
 */

export interface RelayTransport {
  forwardEvent(
    tenantId: string,
    event: LamEventPayload,
  ): Promise<{ status: string; event_id: string }>;
}

export interface RelaySummary {
  attempted: number;
  relayed: number;
  skipped: number;
  failed: number;
}

const RELAY_CONCURRENCY = 5;
const DEFAULT_LIMIT = 20;
const MAX_ERROR_LENGTH = 500;

async function mapWithConcurrency<T>(items: T[], limit: number, fn: (item: T) => Promise<void>): Promise<void> {
  let next = 0;
  const workers = Array.from({ length: Math.min(limit, items.length) }, async () => {
    while (next < items.length) {
      const item = items[next++];
      await fn(item);
    }
  });
  await Promise.all(workers);
}

export async function relayPendingEvents(
  orgId: string,
  userId: string,
  transport: RelayTransport = new LamAdapterClient(),
  limit: number = DEFAULT_LIMIT,
): Promise<RelaySummary> {
  const rows = await listPendingEvents(orgId, userId, limit);
  const summary: RelaySummary = {
    attempted: rows.length,
    relayed: 0,
    skipped: 0,
    failed: 0,
  };

  await mapWithConcurrency(rows, RELAY_CONCURRENCY, async (row) => {
    const normalized = normalizeEvent(
      {
        id: row.eventId,
        event_type: row.eventType,
        payload: row.payload,
        session_id: row.sessionId ?? undefined,
        created_at: row.occurredAt ?? undefined,
      },
      userId,
    );

    if (!normalized.lamEvent) {
      await markSkipped(orgId, row.eventId, normalized.ineligibleReason ?? 'INELIGIBLE');
      summary.skipped += 1;
      return;
    }

    try {
      const result = await transport.forwardEvent(orgId, normalized.lamEvent);
      if (result.status === 'relay_queued') {
        await markFailed(orgId, row.eventId, 'LAM_UNREACHABLE');
        summary.failed += 1;
        return;
      }
      await markRelayed(orgId, [row.eventId]);
      summary.relayed += 1;
    } catch (error: any) {
      const message =
        typeof error?.message === 'string' && error.message.length > 0
          ? error.message.slice(0, MAX_ERROR_LENGTH)
          : 'RELAY_ERROR';
      await markFailed(orgId, row.eventId, message);
      summary.failed += 1;
    }
  });

  return summary;
}
