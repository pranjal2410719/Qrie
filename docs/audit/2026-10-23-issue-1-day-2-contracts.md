# Issue #1 - Day 2 Core Flow and Contracts

- **Issue:** [pranjal2410719/Qrie#1](https://github.com/pranjal2410719/Qrie/issues/1)
- **Branch:** `issue-1/day1-baseline` (Day 2 commits stacked on the Day 1 PR)
- **Base:** same PR, [#2](https://github.com/pranjal2410719/Qrie/pull/2)
- **Date:** 2026-10-23
- **Scope:** Qrie application backend only. The LAM service is still not in this
  repository, so LAM-side Day 2 items (BKT, mastery, revision scheduling) are
  recorded as planned, not implemented.

> No production-readiness claim. The database write path added here is covered
> by tests with a mocked store; it has **not** been executed against a live
> Postgres/Supabase instance (see blockers).

---

## 1. Lifecycle traced

Before this change:

```
HTTP POST /sync/events
  -> auth
  -> map ids
  -> 200 "synced"
  -> (nothing stored, nothing forwarded, nothing retried)
```

The client deletes its outbox row on that 200. A response lost after the handler
returned therefore lost the evidence permanently.

After this change:

```
HTTP POST /sync/events
  -> auth (org_id = JWT.schoolId, student_id = JWT.id)
  -> validate batch (1..20 events, per-event schema)
  -> normalize + classify each event        (pure, testable)
  -> INSERT ... ON CONFLICT DO NOTHING      (durable, idempotent)
  -> drain pending events for this student  (best-effort relay)
  -> markRelayed / markSkipped / markFailed
  -> 200 with synced_ids + relay summary
```

A database failure returns `503 SYNC_STORE_UNAVAILABLE` and the client keeps its
outbox. A LAM failure leaves the event `pending` and still returns 200, because
the durable handoff succeeded.

---

## 2. What was added

| File | Purpose |
| --- | --- |
| `supabase/migrations/0014_sync_event_outbox.sql` | `public.sync_event`, idempotency key `(org_id, event_id)`, retry index, RLS with no policies |
| `backend/src/modules/student/contracts.ts` | incoming event schema, legacy->canonical mapping, evidence eligibility, recommendation schema |
| `backend/src/modules/student/event-store.ts` | insert / list pending / mark relayed / skipped / failed |
| `backend/src/modules/student/relay.ts` | bounded-concurrency drain, retry accounting |
| `backend/src/modules/student/routes.ts` | sync route rewritten around persistence |
| `backend/src/modules/lam-integration/client.ts` | configurable timeout (`LAM_TIMEOUT_MS`) |
| `backend/src/app.ts` | Zod errors -> `422 VALIDATION_ERROR` instead of `500` |
| `docs/CONTRACTS.md` | canonical event/state/recommendation contract |
| `docs/API_CONTRACT.md` | corrected to match the implementation |

### Contract decisions recorded

- `student_id` is taken from the JWT; a body value is ignored.
- An attempt with no verdict is **not** a wrong answer: it is skipped with
  `MISSING_CORRECTNESS`.
- Missing session/concept/item/timestamp is a labelled skip, not a default.
- Mastery probability and mastery confirmation are separate concepts; only the
  former is even modelled, and only in LAM (not here).
- Recommendations carry a stable `reason_code` and `policy_version`;
  `safe_fallback: true` means LAM did not produce it.

---

## 3. Test evidence

Command: `npm test` in `backend/`

| Suite | Tests |
| --- | --- |
| `contracts.test.ts` (new) | 12 - canonical mapping, legacy envelope, provenance, every ineligibility reason, recommendation schema |
| `student_sync.test.ts` (new) | 9 - auth, batch limits, JWT identity, replay, intra-batch duplicate, 503, deferred relay, empty batch |
| `relay.test.ts` (new) | 6 - relay success, skip, unreachable, exception, tenant scoping, empty queue |
| `error_handling.test.ts` (+1) | 3 - malformed JSON, unknown route, Zod `422` |
| existing suites | 21 |

Result: **9 files, 51 tests, all passing.** Build (`tsc`) passes.

The LAM adapter test still exercises the real `forwardEvent` signing path with a
mocked `fetch`; no network call is made.

### HTTP probes against `node dist/server.js` (no database, `LAM_RELAY_ENABLED=false`)

| Request | Status | Observation |
| --- | --- | --- |
| `POST /api/v1/sync/events`, no token | 401 | `UNAUTHORIZED` |
| `POST /api/v1/sync/events`, `{"events":[]}` | 200 | success, 0 synced, relay disabled |
| `POST /api/v1/sync/events`, canonical event | 503 | `SYNC_STORE_UNAVAILABLE` - no false acknowledgement without a store |
| `POST /api/v1/sync/events`, legacy event | 503 | same |
| `POST /api/v1/sync/events`, 21 events | 400 | `events: Array must contain at most 20 element(s)` |
| `POST /api/v1/admin/classes`, `grade: 99` | 422 | `VALIDATION_ERROR`, `details[0].path = grade` |

The 503 rows are the important ones: before Day 2 the same request returned 200
and the client deleted its outbox.

---

## 4. Capability status after Day 2

| Capability | Status | Evidence |
| --- | --- | --- |
| Batch validation (size, field types) | **verified** | `student_sync.test.ts` |
| Durable persistence | **implemented, DB path unverified** | store mocked in tests; migration not applied |
| Idempotent replay | **verified in application tests; SQL unverified** | `on conflict` + duplicate tests |
| Tenant scoping of the outbox | **verified** | store called with JWT `schoolId`; PK includes `org_id` |
| Evidence eligibility rules | **verified** | `contracts.test.ts` |
| Recommendation schema | **verified** | `contracts.test.ts` |
| LAM relay + retry accounting | **verified with fake transport** | `relay.test.ts` |
| Relay against a live LAM | **blocked** | LAM service absent |
| Mastery / BKT / review scheduling | **not implemented here** | LAM owns it |
| Mobile sends session/concept | **not implemented (client)** | outbox payload inspected |
| Answer route emits evidence | **not implemented** | still hardcoded grading |
| Admin Zod validation returns 422 | **verified** | `error_handling.test.ts` |

---

## 5. Blockers and follow-ups

1. **Migration not applied.** `0014_sync_event_outbox.sql` is static-only for the
   same reason as Day 1: no Supabase/Docker stack, PostgreSQL installer download
   returned HTTP 403. The SQL is idempotent and additive.
2. **Mobile payload gap.** `OutboxSyncWorker` sends
   `{id, event_type, payload, created_at}` but no `session_id` or
   `concept_ids`. Real mobile batches will be stored and marked `skipped`
   (`MISSING_SESSION_ID`, then `MISSING_CONCEPT_IDS`). The app must include both
   before any evidence reaches LAM. This is a client change and is outside the
   backend PR.
3. **No drain worker.** Relay retries only when the student syncs again. A cron
   or queue worker is the next step once the store has run against a real
   database.
4. **`/learning/sessions/:id/answers`** still does not write an event. It should
   enqueue the same canonical event so grading and evidence cannot diverge.
5. **LAM Day 2 items** (BKT scenarios, assisted vs unassisted, misconception,
   revision scheduling) cannot be exercised without the LAM service.

---

## 6. Non-claims

- The outbox table is a **bridge**, not the canonical `public.ledger_event`.
  It uses text ids because the backend still uses fixture ids.
- Persistence has not been proven against a live database in this environment.
- Duplicate delivery is proven at the application boundary and by the SQL
  `on conflict` clause, not by a live concurrent test.
- No recommendation is served over HTTP yet; only the schema and the fallback
  object are validated.
