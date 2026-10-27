import { Database } from '../database/index.js';
import { normalizeEvent } from '../modules/student/contracts.js';
import {
  listSkippedEventsForReplay,
  requeueSkippedEvents,
  type ReplayDryRunEvent,
} from '../modules/student/event-store.js';

interface CliOptions {
  orgId: string;
  userId: string | null;
  limit: number;
  apply: boolean;
  reason: string;
}

function parseArgs(argv: string[]): CliOptions {
  const options: CliOptions = {
    orgId: '',
    userId: null,
    limit: 200,
    apply: false,
    reason: 'MANUAL_REPLAY',
  };

  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    const next = argv[i + 1];
    if (arg === '--org-id' && next) {
      options.orgId = next;
      i++;
    } else if (arg === '--user-id' && next) {
      options.userId = next;
      i++;
    } else if (arg === '--limit' && next) {
      options.limit = Math.max(1, Math.min(1000, Number.parseInt(next, 10) || options.limit));
      i++;
    } else if (arg === '--reason' && next) {
      options.reason = next;
      i++;
    } else if (arg === '--apply') {
      options.apply = true;
    }
  }

  if (!options.orgId) {
    throw new Error('Missing --org-id. Usage: npm run sync:requeue-skipped -- --org-id <tenant> [--user-id <id>] [--limit 200] [--reason TICKET] [--apply]');
  }

  return options;
}

function classifyReplayEligibility(row: ReplayDryRunEvent): { eligible: boolean; reason: string | null } {
  const normalized = normalizeEvent(
    {
      id: row.eventId,
      event_type: row.eventType,
      payload: row.payload,
      session_id: row.sessionId ?? undefined,
      created_at: row.occurredAt ?? undefined,
    },
    row.payload?.lamEvent?.student_id && typeof row.payload.lamEvent.student_id === 'string'
      ? row.payload.lamEvent.student_id
      : 'replay-validation-only',
  );
  return { eligible: Boolean(normalized.lamEvent), reason: normalized.ineligibleReason };
}

async function main() {
  const options = parseArgs(process.argv.slice(2));
  const rows = await listSkippedEventsForReplay(options.orgId, options.userId, options.limit);

  const eligible: string[] = [];
  const blocked: Array<{ eventId: string; reason: string | null }> = [];
  for (const row of rows) {
    const decision = classifyReplayEligibility(row);
    if (decision.eligible) eligible.push(row.eventId);
    else blocked.push({ eventId: row.eventId, reason: decision.reason });
  }

  const summary = {
    scanned: rows.length,
    eligible: eligible.length,
    blocked: blocked.length,
    applied: false,
    replayedIds: [] as string[],
  };

  if (options.apply && eligible.length > 0) {
    summary.replayedIds = await requeueSkippedEvents(
      options.orgId,
      eligible,
      `${options.reason}:${new Date().toISOString()}`,
    );
    summary.applied = true;
  }

  console.log(JSON.stringify({ options, summary, blocked }, null, 2));
}

main()
  .catch((error) => {
    console.error(`[requeue-skipped-sync-events] ${error instanceof Error ? error.message : String(error)}`);
    process.exitCode = 1;
  })
  .finally(async () => {
    await Database.close();
  });
