# Qrie Student App — Project Audit & Repository Inventory

**Document Reference:** `docs/student-app/PROJECT_AUDIT.md`  
**Status:** Complete / Verified Against Source  
**Author:** Principal Product Architect & Integration Lead  
**Audit Date:** October 2026  

---

## 1. Executive Summary

This audit establishes the baseline facts across all repositories in the Qrie AI workspace. The findings are derived directly from the code, migrations, schemas, route handlers, and configuration files across:
1. `qrie-platform/` (Current primary multi-tenant workspace: Node.js Fastify backend, Next.js web portal, Supabase migrations, Flutter mobile app)
2. `../lam/` (Decoupled Learning Adaptation Model: FastAPI Python engine)
3. `../qrie-Ai/` (Original curriculum, syllabus datasets, knowledge graph, and pedagogical authoring)

---

## 2. Repository Inventory & Workspace Structure

```
ai-tuitor/
├── qrie-platform/               [PRIMARY WORKSPACE]
│   ├── backend/                 Fastify 4 + TypeScript Application Server
│   │   ├── src/app.ts           Central application builder, RFC 7807 handler
│   │   ├── src/config/          Environment configuration
│   │   ├── src/middleware/auth  Multi-tenant JWT verification & role authorization
│   │   ├── src/modules/
│   │   │   ├── health/          Liveness and readiness checks
│   │   │   ├── admin/           School admin portal endpoints
│   │   │   ├── teacher/         Teacher portal endpoints & class summaries
│   │   │   └── lam-integration/ Server-to-server client with circuit breaker & fallback
│   │   └── tests/               10/10 Vitest tests passing
│   ├── web-app/                 Next.js 14 App Router portal for Teachers & Admins
│   ├── android-app/qrie/        Flutter client targeting Android entry-level devices
│   ├── supabase/                Database layer
│   │   ├── migrations/          13 SQL migrations (0001 through 0013)
│   │   └── functions/lam-relay/ Deno Edge Function relay to LAM
│   └── docs/                    Architecture records (ADR-001, API, DB, Roadmap)
│
├── lam/                         [INDEPENDENT LEARNING ADAPTATION ENGINE]
│   ├── src/lam/
│   │   ├── api/routes/          /v1/events, /v1/recommendations, /v1/learners, /v1/health
│   │   ├── domain/
│   │   │   ├── mastery/         Bayesian Knowledge Tracing (BKT: L0, T, G, S)
│   │   │   ├── assistance/      9-level assistance ladder (Rungs 0 through 8)
│   │   │   ├── recommendation/  6-tier pedagogical recommendation policy
│   │   │   ├── retrieval/       Decaying half-life spaced review scheduler
│   │   │   ├── diagnosis/       Misconception hypothesis finite state machine
│   │   │   └── curriculum/      Concept dependency graph validator
│   │   └── infrastructure/      PostgreSQL ledger & student state repositories
│   └── tests/                   Comprehensive pytest suite
│
└── qrie-Ai/                     [NCERT CURRICULUM & ENGINE ARTIFACTS]
    ├── content/                 Full NCERT interactive lessons (Classes 7, 9, 10 Science & Math)
    └── packages/
        ├── syllabus/            Verified NCERT syllabus definitions for Classes 6–11
        ├── knowledge-graph/     Concept DAGs, prerequisites, and diagnostic probes
        ├── pedagogy/            Assistance level definitions & intervention prompts
        └── tutor-judge/         Answer verification rules & symbolic checkers
```

---

## 3. Backend API Inventory (qrie-platform/backend)

The backend exposes routes under Fastify. Here is the exact verified inventory:

| Method & Route | Module | Auth Requirement | Tenant Scope | Implemented Status | Flutter Student App Usage |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `GET /health/live` | Health | Public | None | ✅ Implemented | Pre-flight connectivity check |
| `GET /health/ready` | Health | Public | System DB + LAM | ✅ Implemented | Network state & backend readiness |
| `GET /api/v1/admin/school` | Admin | Bearer JWT (`school_admin`, `super_admin`) | `school_id` | ✅ Implemented | Admin portal only |
| `POST /api/v1/admin/classes` | Admin | Bearer JWT (`school_admin`) | `school_id` | ✅ Implemented | Admin portal only |
| `POST /api/v1/admin/students` | Admin | Bearer JWT (`school_admin`) | `school_id` | ✅ Implemented | Admin portal only |
| `POST /api/v1/admin/teachers` | Admin | Bearer JWT (`school_admin`) | `school_id` | ✅ Implemented | Admin portal only |
| `GET /api/v1/teacher/classes` | Teacher | Bearer JWT (`teacher`) | `school_id` + teacher ID | ✅ Implemented | Teacher portal only |
| `GET /api/v1/teacher/classes/:classId/students` | Teacher | Bearer JWT (`teacher`) | `school_id` + class ID | ✅ Implemented | Teacher portal only |
| `GET /api/v1/teacher/classes/:classId/mastery-summary` | Teacher | Bearer JWT (`teacher`) | `school_id` + class ID | ✅ Implemented | Teacher portal only |
| `POST /api/v1/auth/session` | Auth | Bearer JWT (Supabase Auth) | User session | ⚠️ Documented in `API_CONTRACT.md`, requires student route registration | Student session bootstrap |
| `POST /api/v1/learning/sessions/start` | Learning | Bearer JWT (`student`) | `school_id` + student ID | ⚠️ Documented in `API_CONTRACT.md`, needs Fastify implementation | Student learning session start |
| `POST /api/v1/learning/sessions/:id/attempt` | Learning | Bearer JWT (`student`) | `school_id` + session ID | ⚠️ Documented in `API_CONTRACT.md`, needs Fastify implementation | Answer submission & verification |
| `GET /api/v1/learning/recommendations` | Learning | Bearer JWT (`student`) | `school_id` + student ID | ⚠️ Documented in `API_CONTRACT.md`, implemented in `LamAdapterClient` | Next-action recommendation |
| `GET /api/v1/learning/reviews/due` | Learning | Bearer JWT (`student`) | `school_id` + student ID | ⚠️ Missing from Fastify router | Due spaced retrieval items |
| `GET /api/v1/curriculum/subjects` | Curriculum | Bearer JWT (`student`) | `grade` scope | ⚠️ Missing from Fastify router | Curriculum subject picker |
| `GET /api/v1/curriculum/chapters` | Curriculum | Bearer JWT (`student`) | `subject` + `grade` | ⚠️ Missing from Fastify router | Chapter & topic browser |

---

## 4. Database Schema & Migration Audit (supabase/migrations)

The database schema has 13 sequential migrations with strict row-level security:

1. `0001_student_state.sql`: Key-value JSONB store per student (`user_id`, `key`, `value`, `updated_at`). Secured by RLS (`auth.uid() = user_id`).
2. `0002_deleted_account.sql`: Tombstone table for GDPR/DPDP compliant student account deletion.
3. `0003_relay_budget.sql`: Token & relay unit billing quotas per organization.
4. `0004_prepared_class.sql`: Teacher lesson plan storage.
5. `0005_tenancy.sql`:
   - `organization`: Multi-tenant boundary (`id`, `kind` in `solo`, `school`, `name`).
   - `membership`: Connects `users` to `organization` with roles (`admin`, `teacher`, `student`).
   - Security definer helper `is_org_member(org_id)`.
6. `0006_ledger.sql`:
   - `learning_session`: Immutable session record (`id` UUID, `org_id`, `user_id`, `source` in `class`, `quiz`, `diagnostic`, `doubt`, `topic_ref`, `started_at`, `ended_at`, `active_ms`).
   - `ledger_event`: Append-only interaction log with client-minted UUID for idempotency.
7. `0007_retention.sql`: Data retention rules and automated archival.
8. `0008_usage.sql` & `0010_usage_cost_rls.sql`: Telemetry cost and token tracking.
9. `0011_close_session_once.sql`: Idempotent session closure trigger.
10. `0013_learner_model.sql`:
    - `concept_state`: Derived belief table written **only** by `service_role`.
    - Tracks `mastery`, `unassisted_mastery`, `assisted_performance`, `observations`, `unassisted_observations`, `taught_count`, `last_practiced_at`, `next_review_at`, `retrieval_count`.

---

## 5. LAM Integration Audit (Independent Service)

The Learning Adaptation Model in `../lam` is fully functional and completely decoupled:

### A. Authentication
- Server-to-server JWT using HMAC-SHA256.
- Secret: `LAM_JWT_SECRET`.
- Header: `{ alg: "HS256", typ: "JWT" }`.
- Claims: `{ sub: "qrie-relay-<tenant>", tenant_id, school_id, roles: ["service"], iss: "lam-auth", aud: "lam-service" }`.
- **Finding:** The Flutter student app must never possess `LAM_JWT_SECRET`. All interactions flow through the Qrie backend adapter.

### B. Route Endpoints Verified in LAM
1. `POST /v1/events`: Ingests learning interaction events into the immutable ledger and updates BKT parameters atomically.
2. `POST /v1/recommendations`: Evaluates learner state and returns deterministic next-action recommendations according to the 6-tier policy.
3. `GET /v1/learners/{learner_id}/reviews`: Calculates scheduled and overdue spaced reviews based on decaying memory strength.
4. `GET /v1/learners/{learner_id}/state`: Returns concept mastery vectors, uncertainty, and assistance statistics.
5. `GET /v1/health/ready`: Probes database and engine health.

### C. Backend Relay (`backend/src/modules/lam-integration/client.ts`)
- Implements `LamAdapterClient`.
- Handles signed JWT generation.
- Implements 5-second timeout with automated fallback:
  ```json
  {
    "action_type": "independent_practice",
    "assistance_level": 0,
    "priority_tier": "tier_safe_fallback",
    "reason_code": "LAM_UNREACHABLE_FALLBACK",
    "suggested_strategy": "continue_current_topic",
    "safe_fallback": true
  }
  ```

---

## 6. Gap Matrix & Required Actions

| Capability | Current State in Repository | Evidence | Gap for Student App | Required Action |
| :--- | :--- | :--- | :--- | :--- |
| **Student Auth Session** | Verified in Supabase Auth & JWT middleware | `backend/src/middleware/auth.ts` | Endpoint `POST /api/v1/auth/session` needs exposure for mobile | Register session route in Fastify router |
| **Curriculum Discovery** | Datasets exist in `qrie-Ai/packages/syllabus` | `qrie-Ai/packages/syllabus/data/` | Not served via Fastify backend endpoints | Add curriculum controller in Fastify to serve syllabus |
| **Session & Attempt API** | Tables exist in `0006_ledger.sql`; adapter exists | `supabase/migrations/0006_ledger.sql` | Fastify endpoint `/api/v1/learning/sessions` missing | Implement student learning controller in backend |
| **LAM Recommendation** | Fully implemented in LAM and Backend Client | `backend/src/modules/lam-integration/client.ts` | Client route `/api/v1/learning/recommendations` missing | Connect Fastify student route to `LamAdapterClient` |
| **Spaced Review Due List** | Implemented in LAM (`/v1/learners/{id}/reviews`) | `lam/src/lam/api/routes/reviews.py` | Backend relay endpoint missing | Implement review relay in backend |
| **Concept State Progress** | Database table `concept_state` exists | `supabase/migrations/0013_learner_model.sql` | Endpoint to query student's own progress missing | Expose read-only student progress route |
| **Offline Sync Outbox** | Idempotent DB table `ledger_event` (`on conflict do nothing`) | `0006_ledger.sql` | Flutter client offline sync queue not implemented | Implement SQLite/Drift sync outbox in Flutter |
| **NCERT Content Rendering**| Content JSONs exist in `qrie-Ai/content/` | `qrie-Ai/content/*/lesson.json` | Flutter parser for lesson elements needed | Build Flutter parser for text, diagram, questions |
