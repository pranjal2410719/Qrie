# Qrie Backend Baseline Audit & Readiness Report

**Date:** 2026-10-26  
**Auditor:** Antigravity AI Coding Agent  
**Branch:** `pr-2` (tracking `origin/pr-2`)  
**Commit SHA:** `c26e3bc48b3713f044bb7133b3b44b82d9ee9ee7`  
**Base Branch:** `main` (at `8e0ccdd403a0018a5280188445a7bc822585806d`)  
**Open PR:** [PR #2](https://github.com/pranjal2410719/Qrie/pull/2) (`aarixu/Qrie_ashish:issue-1/day1-baseline`, head `4103767`)  
**Notion Tracker:** [Qrie Backend: Master Execution Plan & Verification Matrix](https://app.notion.com/p/4058e0cfca06814aa597c4488631bf5c)  

---

## 1. Executive Summary

This baseline audit establishes the exact technical status of the Qrie backend prior to code modifications.

### Verified Capabilities
1. **Compilation:** `npm run build` runs `tsc` with zero errors.
2. **Unit Test Suite:** Vitest reports 73 passed tests across 12 test suites.
3. **Configuration Guardrails:** Day 2 hardening correctly prevents startup in production if `JWT_SECRET`, `LAM_JWT_SECRET`, `DATABASE_URL` use default values, if `ALLOW_DEMO_AUTH` is true, or if `ALLOWED_ORIGINS` is empty.
4. **Error Handling:** RFC 7807 problem details with `x-request-id` correlation IDs are implemented and verified.
5. **CORS Allowlist:** Origin reflection removed; explicit allowlist verified.

### Observed Gaps & Deficiencies
1. **PostgreSQL Persistence Tests Skipped:** 11 database integration tests in `tests/event_persistence.test.ts` are skipped because PostgreSQL is not reachable on `localhost:5432`.
2. **Answer Grading is Hardcoded:** `POST /api/v1/learning/sessions/:sessionId/answers` grades only demo question `q4` with fixed arithmetic and option index checks. It does not load question records from the database or produce canonical learning events.
3. **Mobile Event Contract Mismatch:** Mobile outbox payloads do not supply `session_id` or `concept_ids`. `normalizeEvent` marks these events `skipped` with `MISSING_SESSION_ID` or `MISSING_CONCEPT_IDS`, preventing them from ever reaching LAM.
4. **Outbox Relay Concurrency:** `listPendingEvents` queries rows without `FOR UPDATE SKIP LOCKED` or an atomic lease. Concurrent sync requests can select and relay identical rows simultaneously.
5. **Fixture Routes:** Teacher and admin route handlers continue to return static fixture arrays rather than querying PostgreSQL.
6. **No Fastify Recommendation Route:** `LamAdapterClient.getRecommendation()` exists, but no Fastify HTTP endpoint calls it or serves recommendations to students.

---

## 2. Environment & Working-Tree State

### Git Working Tree
- `modified: website/package.json` (uncommitted dependency changes: added `motion`, `react-icons`).
- `untracked: website/package-lock.json`.
- **Policy:** Preserved intact. No destructive resets or discards.

### Tooling Availability
- Node.js & npm: Verified.
- TypeScript: `v5.x` via `tsc`.
- Vitest: `v3.2.7`.
- Docker: `v29.9.2` installed; Docker Desktop daemon currently stopped.
- Supabase CLI: Not installed locally.

---

## 3. Test Execution Baseline

```text
> @qrie/backend@0.1.0 test
> vitest run --run

 RUN  v3.2.7 C:/projects/Qrie/backend

 ✓ tests/event_persistence.test.ts (11 tests | 11 skipped) 68ms
 ✓ tests/cors.test.ts (7 tests) 814ms
 ✓ tests/auth_tenant.test.ts (4 tests) 167ms
 ✓ tests/student_branding.test.ts (5 tests) 644ms
 ✓ tests/health.test.ts (4 tests) 173ms
 ✓ tests/student_sync.test.ts (9 tests) 740ms
 ✓ tests/error_handling.test.ts (3 tests) 258ms
 ✓ tests/event_store_unit.test.ts (13 tests) 40ms
 ✓ tests/contracts.test.ts (12 tests) 37ms
 ✓ tests/relay.test.ts (6 tests) 36ms
 ✓ tests/config.production.test.ts (8 tests) 26ms
 ✓ tests/lam_adapter.test.ts (2 tests) 41ms

 Test Files  12 passed (12)
      Tests  73 passed | 11 skipped (84)
   Duration  5.19s
```

---

## 4. Phase 0 Readiness Gate (G1) Verdict: PASSED

- Exact branch and commit recorded.
- Working tree protected.
- Baseline test and build output captured.
- Master execution plan created and synchronized in Notion.
- Phase 1 (Configuration & Auth Hardening) is approved to begin.
