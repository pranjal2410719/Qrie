# Qrie Application Backend API Contract (v1)

Base URL: `http://localhost:4000/api/v1`
Authentication: `Authorization: Bearer <JWT>`

Status: **corrected 2026-10-23 (issue #1, Day 2)**. Earlier revisions of this
document described endpoints and readiness checks that did not exist. Everything
below is what the code actually does. See `docs/CONTRACTS.md` for the learning
event and recommendation schemas.

Legend: **verified** (tested or probed), **partial** (works with a stated
limit), **demo** (fixture/no real data), **not implemented**.

---

## Error envelope

Every error is RFC 7807-shaped:

```json
{
  "type": "about:blank",
  "title": "BAD_REQUEST",
  "status": 400,
  "detail": "school_code query parameter is required",
  "instance": "/api/v1/public/school/branding",
  "requestId": "req_...",
  "details": []
}
```

`title` is a stable machine code (`BAD_REQUEST`, `UNAUTHORIZED`, `FORBIDDEN`,
`NOT_FOUND`, `VALIDATION_ERROR`, `SYNC_STORE_UNAVAILABLE`,
`INTERNAL_SERVER_ERROR`, or a Fastify code such as
`FST_ERR_CTP_INVALID_JSON_BODY`). **verified**

---

## 1. System health

| Route | Result |
| --- | --- |
| `GET /health/live` | `200 {"status":"alive"}` — **verified** |
| `GET /health/ready` | `200 {"status":"ready","database":"connected"}` or `503 {"status":"unavailable","database":"disconnected"}` — **verified** |

`/health/ready` checks the database only. It does **not** check LAM; the
`lam_relay` field in the old document never existed.

---

## 2. Public branding and demo auth

### `GET /public/school/branding?school_code=...` — **partial**

Returns branding for the one hardcoded school (`DPS-RKP-042`).

- missing `school_code` → `400 BAD_REQUEST`
- unknown `school_code` → `404 NOT_FOUND` (no DPS leak)
- known code → `200` with `school_id`, `school_name`, `school_code`, `motto`,
  `branding`

It does not read the organization table. **verified**

### `POST /auth/session` — **demo only**

Mints a fixed student identity (`std_aarav_patel`) **without verifying a
credential**. Gated by `ALLOW_DEMO_AUTH` (default true in development, rejected
at startup in production).

```json
{ "access_token": "...", "refresh_token": "ref_...", "user": {...}, "school": {...} }
```

**verified** (including the production guard).

### `GET /student/school/branding` — **demo**

Requires a student JWT. Returns branding with `school_id` echoed from the token.

---

## 3. Learning events

### `POST /sync/events` — **verified**

Requires a student JWT. Persists the batch to `public.sync_event` (idempotent on
`(org_id, event_id)`), then best-effort relays eligible events to LAM.

```json
{
  "events": [
    {
      "id": "evt_1",
      "event_type": "learning.answer_submitted",
      "created_at": "2026-10-23T10:05:00.000Z",
      "payload": {
        "question_id": "q4",
        "session_id": "sess_1",
        "concept_ids": ["pressure"],
        "is_correct": true,
        "assistance_rung": 0,
        "duration_ms": 4200
      }
    }
  ]
}
```

Constraints: `events` required, max 20, each `id` 1..128 chars.

Response:

```json
{
  "status": "success",
  "synced_count": 1,
  "synced_ids": ["evt_1"],
  "duplicates": 0,
  "relay": { "enabled": true, "attempted": 1, "relayed": 1, "skipped": 0, "failed": 0 }
}
```

- `synced_ids` are durably stored and safe to delete from the device outbox.
- `duplicates` counts replay/repeated ids.
- `relay.deferred: true` means the write succeeded but the LAM drain could not
  run; the event remains `pending`.
- database unavailable → `503 SYNC_STORE_UNAVAILABLE` (do not delete locally).
- relay disabled → `relay: {"enabled": false, ...}`.

Evidence eligibility (missing session/concept/item/timestamp/correctness) is in
`docs/CONTRACTS.md`. Ineligible events are stored and marked `skipped`.

### `POST /learning/sessions/:sessionId/answers` — **partial / demo**

Requires a student JWT. Grades one hardcoded question (`q4`, numeric answer 25)
plus a two-option heuristic. It is not backed by a question bank, does not
persist an event, and does not call LAM.

```json
{
  "question_id": "q4",
  "is_correct": true,
  "explanation": "...",
  "xp_awarded": 20,
  "is_assisted": false,
  "timestamp": "..."
}
```

---

## 4. Teacher portal (`/teacher/...`) — **demo, role-gated**

Requires `teacher` or `school_admin`. Every response is fixture data scoped only
by the token's `schoolId`; no class or student is read from the database.

| Route | Returns |
| --- | --- |
| `GET /teacher/classes` | two fixture classes |
| `GET /teacher/classes/:classId/students` | two fixture students with struggle flags |
| `GET /teacher/classes/:classId/mastery-summary` | fixture topic distribution |

---

## 5. Admin portal (`/admin/...`) — **demo, role-gated**

Requires `school_admin` or `super_admin`.

| Route | Behaviour |
| --- | --- |
| `GET /admin/school` | fixture school metadata from the token's `schoolId` |
| `POST /admin/classes` | validates `{grade 6..12, section 1..8, academic_year?}`, returns a synthesized class (not stored) — **422 on invalid body** |
| `POST /admin/students` | validates `{full_name, email, grade 6..12, class_id, roll_number}`, returns a synthesized student (not stored) — **422 on invalid body** |

---

## 6. Removed from this document

The previous version claimed `POST /learning/sessions/start`, a LAM `next_action`
in the answer response, and a `lam_relay` readiness field. None of those exist in
the implementation and they are **not implemented**.
