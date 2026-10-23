# Qrie <-> LAM Contracts

Status: **Day 2 draft**, 2026-10-23. This document describes the contracts the
Qrie application backend implements **today**, plus the parts that are owned by
the LAM service and are therefore not implemented in this repository.

Legend: **verified** = exercised by a test or an HTTP probe in this repo;
**partial** = implemented but with a stated limit; **planned** = not implemented
here, recorded so it is not mistaken for working.

---

## 0. Where the boundary is

| Side | Lives in | Status |
| --- | --- | --- |
| Client/tenant identity | `backend/src/middleware/auth.ts` (JWT claims) | verified |
| Event intake + durable outbox | `backend/src/modules/student/{contracts,event-store,relay}.ts` | verified with mocks / DB path unverified |
| LAM event/recommendation transport | `backend/src/modules/lam-integration/client.ts`, `supabase/functions/lam-relay/` | partial |
| Learner state, BKT, mastery, review scheduling | LAM service (not in this repo) | **planned / not implemented here** |

The application backend never computes mastery. It validates, stores and relays
evidence; it may cache a recommendation, but it must not invent one. The only
recommendation this repo can produce without LAM is the explicit
`LAM_UNREACHABLE_FALLBACK`.

---

## 1. Client and tenant identity

Verified from the JWT, not from the request body.

| Claim | Type | Meaning |
| --- | --- | --- |
| `id` | string | student/user id |
| `schoolId` | string | tenant id; every sync row is keyed by it |
| `role` | `student \| teacher \| school_admin \| super_admin` | authorization |
| `email` | string | display only |

Rules:

- `POST /api/v1/sync/events` derives `org_id` from `schoolId` and `student_id`
  from `id`. A `student_id` in the body is ignored (**verified** by
  `tests/contracts.test.ts` and `tests/student_sync.test.ts`).
- The current ids are fixture strings (`sch_dps_rkp`, `std_aarav_patel`), not
  UUIDs. `public.ledger_event` keys on UUID org/user ids, which is why the
  outbox uses a text-keyed bridge table (`public.sync_event`) for now.

---

## 2. Learning event

### 2.1 Incoming envelope (what the mobile outbox sends)

```json
{
  "events": [
    {
      "id": "0f6c2f0e-...",
      "event_type": "learning.answer_submitted",
      "created_at": "2026-10-23T10:05:00.000Z",
      "payload": {
        "question_id": "q4",
        "subject_id": "science",
        "is_correct": true,
        "assistance_rung": 0,
        "duration_ms": 4200
      }
    }
  ]
}
```

- Batch size: **1..20**. Empty batches are accepted and are a no-op write.
- `id` is client-minted at the moment of the event and is the idempotency key.
- `created_at` is the device clock and is treated as untrusted.

### 2.2 Canonical event (what LAM receives)

Flat, one event per POST to LAM `/v1/events`:

| Field | Type | Required | Source |
| --- | --- | --- | --- |
| `event_id` | string | yes | envelope `id` |
| `student_id` | string | yes | JWT `id` |
| `session_id` | string | yes | envelope `session_id` or `payload.session_id` |
| `concept_ids` | string[] | yes (>=1) | envelope or `payload.concept_ids` / `payload.concept_id` |
| `item_id` | string | yes | envelope or `payload.item_id` / `payload.question_id` |
| `timestamp` | ISO-8601 | yes | envelope `timestamp` / `payload.timestamp` / `created_at` |
| `event_type` | `attempt\|hint\|explanation\|assessment\|review` | yes | mapped (below) |
| `correctness` | boolean | attempts/assessments | `correctness` or `payload.is_correct` |
| `attempt_number` | int >= 0 | no | `attempt_number` |
| `assistance_level` | int 0..9 | no | `assistance_level` or `payload.assistance_rung` |
| `hints_used` | int >= 0 | no | `hints_used` |
| `response_time_ms` | int >= 0 | no | `response_time_ms` or `payload.duration_ms` |
| `difficulty` | 0..1 | no | `difficulty` |
| `assessment_mode` | `independent\|assisted\|delayed\|transfer` | no | explicit, else derived from rung |

Event type mapping (**verified** in `tests/contracts.test.ts`):

| Client `event_type` | LAM `event_type` |
| --- | --- |
| `learning.answer_submitted` | `attempt` |
| `learning.hint_requested` | `hint` |
| `learning.explanation_viewed` | `explanation` |
| `learning.assessment_submitted` | `assessment` |
| `learning.review_completed` | `review` |
| canonical LAM values | unchanged |
| anything else | **not relayed** (`UNSUPPORTED_EVENT_TYPE`) |

### 2.3 Evidence eligibility

An event may be **stored** without being eligible to become learner evidence.
Ineligible events are marked `skipped` with one of these reasons and are never
sent to LAM:

| Reason | Meaning |
| --- | --- |
| `UNSUPPORTED_EVENT_TYPE` | no LAM equivalent |
| `MISSING_SESSION_ID` | cannot attribute to a sitting |
| `MISSING_CONCEPT_IDS` | cannot attribute to a concept |
| `MISSING_ITEM_ID` | cannot attribute to an item |
| `MISSING_TIMESTAMP` | no trustworthy device time |
| `MISSING_CORRECTNESS` | an attempt with no verdict is not a wrong answer |

This is the "invalid evidence must not silently corrupt learner state" rule: a
missing field is a labelled skip, not a default value.

**Known gap (partial):** the current mobile outbox does **not** send
`session_id` or `concept_ids`, so real mobile batches are stored but skipped.
The app needs to include both for evidence to reach LAM. This is a client change
and is deliberately out of scope for the backend PR.

---

## 3. Learner state (owned by LAM, not implemented here)

Documented so the boundary is explicit:

| Field | Meaning | Status in this repo |
| --- | --- | --- |
| `mastery` | probability from all evidence, assisted included | planned (LAM) |
| `unassisted_mastery` | rung-0 evidence only | planned (LAM) |
| `assisted_performance` | performance with help | planned (LAM) |
| `observations` | evidence count | planned (LAM) |
| `unassisted_observations` | rung-0 evidence count | planned (LAM) |
| `memory_strength`, `next_review_at` | spaced retrieval | planned (LAM) |
| explicit mastery confirmation | separate state from probability | planned (LAM) |

Rules the backend must not violate:

- A probability is not a confirmation. `mastery = 0.9` and "confirmed" are
  different facts and must not share a field.
- Assisted success must not be recorded as unassisted mastery.
- Zero observations is not mastery zero.

`supabase/migrations/0013_learner_model.sql` defines the intended shape; no
backend code reads or writes it.

---

## 4. Recommendation and reason codes

```json
{
  "recommendation_id": "rec_...",
  "action_type": "independent_practice",
  "target_concept_id": "c1",
  "assistance_level": 0,
  "priority_tier": "tier_safe_fallback",
  "reason_code": "LAM_UNREACHABLE_FALLBACK",
  "suggested_strategy": "continue_current_topic",
  "rationale": "Deterministic fallback engaged while LAM service is recovering.",
  "policy_version": "fallback-v1",
  "safe_fallback": true,
  "uncertainty": 0.5
}
```

- `reason_code` is a stable machine string, never prose. `policy_version`
  identifies the rule set. `rationale` is for humans and may change.
- `safe_fallback: true` means the recommendation was **not** produced by LAM.
  A client must not present it as an adaptive decision.
- `assistance_level` is bounded to 0..9 and is validated by
  `lamRecommendationSchema` (**verified**).
- The only reason code this repository knows is
  `LAM_UNREACHABLE_FALLBACK`. LAM owns the rest.

Help-level ladder: 0 = independent, higher rungs add support up to 9. The
backend forwards the rung it is given and never escalates on its own. Bounded
transitions and their reason codes are **planned (LAM)**.

---

## 5. Idempotency, retry and failure semantics

| Situation | Behaviour | Status |
| --- | --- | --- |
| Same `event_id` replayed | `on conflict (org_id, event_id) do nothing`; acknowledged again, inserted once | verified at SQL level / mocked in tests |
| Duplicate inside one batch | collapsed before insert | verified |
| `student_id` in body | ignored; JWT wins | verified |
| Database unavailable | `503 SYNC_STORE_UNAVAILABLE`, no ack | verified |
| LAM unavailable | batch is stored; event stays `pending`, relay retried later | verified |
| Relay keeps failing | retry budget 10 attempts, then terminal `failed` | implemented, DB path unverified |
| Ineligible event | stored, marked `skipped`, never retried | verified |
| Relay drain fails after a successful write | `200` with `relay.deferred = true`; not a client error | verified |

`relay_status` values: `pending` (retryable), `relayed`, `skipped` (terminal),
`failed` (retry budget exhausted).

---

## 6. HTTP summary

`POST /api/v1/sync/events` (student JWT required)

```json
{
  "status": "success",
  "synced_count": 2,
  "synced_ids": ["evt_1", "evt_2"],
  "duplicates": 1,
  "relay": {
    "enabled": true,
    "attempted": 2,
    "relayed": 1,
    "skipped": 1,
    "failed": 0
  }
}
```

- `synced_ids` are safe to delete from the local outbox: every id in it is
  durably stored (not necessarily relayed).
- `duplicates` counts ids that were already present (replay) or repeated in the
  batch.

---

## 7. Unsupported / planned

- BKT, mastery updates, eligibility beyond field presence, misconception
  diagnosis, revision scheduling: **not in this repository**.
- LAM recommendation schema validation at the edge: the schema exists, but no
  HTTP route returns a recommendation today.
- `POST /learning/sessions/:sessionId/answers` still grades one hardcoded
  question and does not emit an event into the outbox. **partial**.
- `docs/API_CONTRACT.md` previously overstated the routes; it has been corrected
  to match this document and the implementation.
