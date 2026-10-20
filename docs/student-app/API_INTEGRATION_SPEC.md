# Qrie Student App — API Integration Specification

**Document Reference:** `docs/student-app/API_INTEGRATION_SPEC.md`  
**Status:** Approved Specification  
**Author:** Backend Integration Architect & Senior API Engineer  
**Base URL:** `http://localhost:4000/api/v1` (Production: `https://api.qrie.ai/api/v1`)  
**Error Standard:** RFC 7807 Problem Details for HTTP APIs  

---

## 1. Endpoint Classification & Readiness Matrix

| Endpoint | Method | Status in Codebase | Source File / Implementation |
| :--- | :--- | :--- | :--- |
| `/health/live` | GET | ✅ Implemented | `backend/src/modules/health/routes.ts` |
| `/health/ready` | GET | ✅ Implemented | `backend/src/modules/health/routes.ts` |
| `/auth/session` | POST | ⚠️ Proposed (in `API_CONTRACT.md`) | Needs route registration in `backend/src/app.ts` |
| `/auth/login` | POST | ⚠️ Proposed | Supabase Auth proxy route |
| `/auth/enroll` | POST | ⚠️ Proposed | Organization enrollment controller |
| `/curriculum/subjects` | GET | ⚠️ Proposed | Connects to `qrie-Ai/packages/syllabus` data |
| `/curriculum/chapters` | GET | ⚠️ Proposed | Connects to `qrie-Ai/packages/syllabus` data |
| `/curriculum/lessons/:id` | GET | ⚠️ Proposed | Serves `qrie-Ai/content/*/lesson.json` |
| `/learning/sessions/start` | POST | ⚠️ Proposed (in `API_CONTRACT.md`) | Inserts into `learning_session` table |
| `/learning/sessions/:id/attempt` | POST | ⚠️ Proposed (in `API_CONTRACT.md`) | Verifies answer, writes `learning_events`, calls LAM |
| `/learning/recommendations` | GET | ⚠️ Partial (Client built) | Exposes `LamAdapterClient.getRecommendation` |
| `/learning/reviews/due` | GET | ⚠️ Partial (LAM endpoint exists) | Relays to `lam/src/lam/api/routes/reviews.py` |
| `/student/progress` | GET | ⚠️ Proposed | Queries `concept_state` (`0013_learner_model.sql`) |
| `/sync/events` | POST | ⚠️ Proposed | Batch idempotent ingestion for offline outbox |

---

## 2. RFC 7807 Standard Error Contract

All error responses from the backend follow the RFC 7807 specification:
```json
{
  "type": "https://api.qrie.ai/errors/UNAUTHORIZED_ACCESS",
  "title": "UNAUTHORIZED_ACCESS",
  "status": 403,
  "detail": "Cross-tenant access forbidden. Student belongs to school_id: sch_dps_delhi.",
  "instance": "/api/v1/learning/sessions/start",
  "requestId": "req_84f9102c7b",
  "details": {
    "attempted_school_id": "sch_other_mumbai"
  }
}
```

---

## 3. Comprehensive Endpoint Specifications

### 3.1 Authentication & Profile Session
#### `POST /auth/session`
- **Purpose:** Exchange or validate Supabase JWT session, returning verified tenant identity and student profile.
- **Headers:** `Authorization: Bearer <SUPABASE_JWT>`
- **Response Schema (`200 OK`):**
  ```json
  {
    "user_id": "usr_7492c10b",
    "email": "aarav.sharma@dps.edu.in",
    "role": "student",
    "school_id": "sch_dps_delhi",
    "full_name": "Aarav Sharma",
    "grade_level": 8,
    "board": "CBSE",
    "lam_student_id": "lam_std_99a81",
    "streak_days": 6,
    "total_xp": 1420,
    "gems": 380
  }
  ```
- **Error Codes:** `401 Unauthorized` (Token expired or malformed), `403 Forbidden` (User is suspended).
- **Screens:** Used by SCR-01 (Splash) and SCR-04 (Home).

---

### 3.2 Curriculum Discovery
#### `GET /curriculum/subjects`
- **Purpose:** Returns available subjects and syllabus metadata for the student's grade.
- **Query Parameters:** `grade=8` (Integer, 6–12)
- **Response Schema (`200 OK`):**
  ```json
  {
    "grade": 8,
    "board": "CBSE",
    "subjects": [
      {
        "id": "mathematics",
        "name": "Mathematics",
        "emoji": "📐",
        "chapters_count": 14,
        "completed_count": 5,
        "progress_ratio": 0.35
      },
      {
        "id": "science",
        "name": "Science",
        "emoji": "🔬",
        "chapters_count": 16,
        "completed_count": 8,
        "progress_ratio": 0.50
      }
    ]
  }
  ```
- **Screens:** Used by SCR-04 (Home) and SCR-05 (Curriculum Browser).

#### `GET /curriculum/chapters`
- **Query Parameters:** `subject=science&grade=8`
- **Response Schema (`200 OK`):**
  ```json
  {
    "subject_id": "science",
    "grade": 8,
    "chapters": [
      {
        "id": "sci_ch01_cell",
        "order": 1,
        "title": "Cell — Structure & Functions",
        "subtitle": "Fundamental unit of life",
        "concepts_count": 6,
        "is_unlocked": true,
        "lessons": [
          {
            "id": "class9-mitochondria",
            "title": "Mitochondria",
            "type": "concept_visual",
            "duration_minutes": 9,
            "xp_reward": 25,
            "is_completed": true
          }
        ]
      }
    ]
  }
  ```

---

### 3.3 Learning Sessions & Authoritative Verification
#### `POST /learning/sessions/start`
- **Purpose:** Starts a new active learning or practice session.
- **Request Body:**
  ```json
  {
    "client_session_id": "c7a840b2-10f4-4d22-92a1-89d9841029ba",
    "subject": "science",
    "target_concept_id": "ncert.sci.08.cell.mitochondria",
    "source": "quiz"
  }
  ```
- **Response Schema (`201 Created`):**
  ```json
  {
    "session_id": "c7a840b2-10f4-4d22-92a1-89d9841029ba",
    "status": "active",
    "target_concept_id": "ncert.sci.08.cell.mitochondria",
    "items": [
      {
        "item_id": "item_cell_01",
        "concept_id": "ncert.sci.08.cell.mitochondria",
        "question_text": "Which organelle is universally known as the powerhouse of the cell?",
        "options": [
          "Ribosome",
          "Mitochondria",
          "Golgi Apparatus",
          "Endoplasmic Reticulum"
        ],
        "format": "single_choice",
        "difficulty": 0.35,
        "xp_reward": 20
      }
    ]
  }
  ```

#### `POST /learning/sessions/:sessionId/attempt`
- **Purpose:** Submits student answer, executes server-side grading, writes immutable ledger event, and relays to LAM.
- **Idempotency Header:** `Idempotency-Key: <CLIENT_EVENT_UUID>`
- **Request Body:**
  ```json
  {
    "event_id": "a90184b2-2931-41fa-8a10-910248a8b1cd",
    "item_id": "item_cell_01",
    "concept_id": "ncert.sci.08.cell.mitochondria",
    "selected_option_index": 1,
    "attempt_number": 1,
    "assistance_level": 0,
    "response_time_ms": 14200,
    "active_ms": 12500
  }
  ```
- **Response Schema (`200 OK`):**
  ```json
  {
    "event_id": "a90184b2-2931-41fa-8a10-910248a8b1cd",
    "is_correct": true,
    "explanation": "Mitochondria produce cellular energy in the form of ATP molecules via cellular respiration.",
    "correct_option_index": 1,
    "xp_earned": 20,
    "streak_updated": 6,
    "next_recommendation": {
      "action_type": "independent_practice",
      "target_concept_id": "ncert.sci.08.cell.chloroplast",
      "suggested_strategy": "advance_to_next_organelle"
    }
  }
  ```

---

### 3.4 Spaced Retrieval & Recommendations
#### `GET /learning/recommendations`
- **Purpose:** Retrieves personalized next-action pedagogical recommendation from LAM.
- **Response Schema (`200 OK`):**
  ```json
  {
    "recommendation_id": "rec_84b291ac",
    "action_type": "spaced_retrieval",
    "target_concept_id": "ncert.math.08.linear_equations.transposition",
    "assistance_level": 0,
    "priority_tier": "tier_due_spaced_retrieval",
    "reason_code": "SPACED_RETRIEVAL_DUE",
    "suggested_strategy": "review_before_decay",
    "rationale": "Concept was practiced 4 days ago; memory consolidation review is due.",
    "policy_version": "lam-v1.4",
    "safe_fallback": false,
    "uncertainty": 0.12
  }
  ```

#### `GET /learning/reviews/due`
- **Purpose:** Fetches list of overdue and due spaced retrieval cards.
- **Response Schema (`200 OK`):**
  ```json
  {
    "learner_id": "lam_std_99a81",
    "total_due_count": 2,
    "items": [
      {
        "concept_id": "ncert.math.08.linear_equations.transposition",
        "chapter_title": "Linear Equations in One Variable",
        "priority": "due_for_review",
        "retention_strength": 0.62,
        "half_life_days": 4.5,
        "days_overdue": 0.8
      }
    ]
  }
  ```

---

### 3.5 Offline Durable Outbox Synchronization
#### `POST /sync/events`
- **Purpose:** Flushes client-minted offline interaction attempts safely.
- **Guarantees:** Server executes `INSERT INTO ledger_event ... ON CONFLICT (id) DO NOTHING` to guarantee idempotent, zero-duplicate ingestion.
- **Request Body:**
  ```json
  {
    "events": [
      {
        "id": "e91b402c-8821-419b-a010-9948c21a00bc",
        "session_id": "c7a840b2-10f4-4d22-92a1-89d9841029ba",
        "concept_id": "ncert.sci.08.cell.mitochondria",
        "item_id": "item_cell_01",
        "is_correct": true,
        "attempt_number": 1,
        "assistance_level": 0,
        "response_time_ms": 8400,
        "active_ms": 7900,
        "created_at": "2026-10-20T14:15:00Z"
      }
    ]
  }
  ```
- **Response Schema (`200 OK`):**
  ```json
  {
    "processed_count": 1,
    "duplicate_count": 0,
    "synced_ids": ["e91b402c-8821-419b-a010-9948c21a00bc"],
    "server_timestamp": "2026-10-20T14:16:30Z"
  }
  ```
