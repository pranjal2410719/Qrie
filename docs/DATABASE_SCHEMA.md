# Qrie AI — Relational Database Schema & Entities

## 1. Core Schema Overview (PostgreSQL / Supabase)

Every table is multi-tenant partitioned using `school_id UUID NOT NULL REFERENCES schools(id) ON DELETE CASCADE`.

```
           +-------------------------+
           |         schools         |
           +------------+------------+
                        | 1
                        |
                        | *
           +------------v------------+
           |          users          |
           +------------+------------+
                        | 1
            +-----------+-----------+
            | 1                     | 1
            v                       v
+-----------+-----------+   +-------+---------------+
|   student_profiles    |   |   teacher_profiles    |
+-----------+-----------+   +-------+---------------+
            | 1                     | 1
            |                       |
            | *                     | *
+-----------v-----------+   +-------v---------------+
|   class_enrollments   |   |   class_assignments   |
+-----------+-----------+   +-------+---------------+
            \                       /
             \ *                 * /
           +--v-------------------v--+
           |         classes         |
           +------------+------------+
                        | 1
                        |
                        | *
           +------------v------------+
           |    learning_sessions    |
           +------------+------------+
                        | 1
                        |
                        | *
           +------------v------------+
           |     learning_events     |
           +-------------------------+
```

---

## 2. Table Definitions

### A. Tenancy & Users
* **`schools`**:
  - `id` (UUID PK): School tenant identifier.
  - `name` (TEXT NOT NULL): Registered name of the school.
  - `code` (VARCHAR(32) UNIQUE NOT NULL): School code (e.g. `DEL-DPS-001`).
  - `status` (VARCHAR(16) NOT NULL DEFAULT 'active'): `active`, `suspended`.
  - `created_at`, `updated_at` (TIMESTAMPTZ).
* **`users`**:
  - `id` (UUID PK): Supabase Auth UID.
  - `school_id` (UUID NOT NULL FK `schools.id`).
  - `email` (TEXT UNIQUE NOT NULL).
  - `role` (VARCHAR(32) NOT NULL): `student`, `teacher`, `school_admin`, `super_admin`.
  - `full_name` (TEXT NOT NULL).
  - `created_at`, `updated_at` (TIMESTAMPTZ).
* **`student_profiles`**:
  - `id` (UUID PK FK `users.id`).
  - `school_id` (UUID NOT NULL FK `schools.id`).
  - `roll_number` (VARCHAR(32)).
  - `grade_level` (INT NOT NULL): 6 through 12.
  - `lam_student_id` (VARCHAR(64) UNIQUE NOT NULL): Stable pseudonymous identifier linked to LAM.
  - `created_at`, `updated_at` (TIMESTAMPTZ).
* **`teacher_profiles`**:
  - `id` (UUID PK FK `users.id`).
  - `school_id` (UUID NOT NULL FK `schools.id`).
  - `employee_id` (VARCHAR(64)).
  - `subjects` (TEXT[] NOT NULL DEFAULT '{}').
  - `created_at`, `updated_at` (TIMESTAMPTZ).

### B. Classes & Enrollments
* **`classes`**:
  - `id` (UUID PK).
  - `school_id` (UUID NOT NULL FK `schools.id`).
  - `grade` (INT NOT NULL): 6–12.
  - `section` (VARCHAR(16) NOT NULL): 'A', 'B', etc.
  - `academic_year` (VARCHAR(16) NOT NULL): e.g. '2026-2027'.
  - `created_at`, `updated_at` (TIMESTAMPTZ).
* **`class_enrollments`**:
  - `id` (UUID PK).
  - `school_id` (UUID NOT NULL FK `schools.id`).
  - `class_id` (UUID NOT NULL FK `classes.id`).
  - `student_id` (UUID NOT NULL FK `student_profiles.id`).
  - UNIQUE(`class_id`, `student_id`).
* **`class_assignments`**:
  - `id` (UUID PK).
  - `school_id` (UUID NOT NULL FK `schools.id`).
  - `class_id` (UUID NOT NULL FK `classes.id`).
  - `teacher_id` (UUID NOT NULL FK `teacher_profiles.id`).
  - `subject` (VARCHAR(64) NOT NULL).
  - UNIQUE(`class_id`, `teacher_id`, `subject`).

### C. Curriculum & Content
* **`curriculum_concepts`**:
  - `id` (VARCHAR(128) PK): NCERT concept identifier (e.g. `ncert.math.08.rational_numbers.properties`).
  - `grade` (INT NOT NULL): 6–12.
  - `subject` (VARCHAR(64) NOT NULL): 'mathematics', 'science'.
  - `chapter_title` (TEXT NOT NULL).
  - `concept_name` (TEXT NOT NULL).
  - `prerequisites` (TEXT[] NOT NULL DEFAULT '{}').

### D. Learning Sessions & Verified Telemetry
* **`learning_sessions`**:
  - `id` (UUID PK).
  - `school_id` (UUID NOT NULL FK `schools.id`).
  - `student_id` (UUID NOT NULL FK `student_profiles.id`).
  - `subject` (VARCHAR(64) NOT NULL).
  - `target_concept_id` (VARCHAR(128) NOT NULL).
  - `started_at` (TIMESTAMPTZ NOT NULL).
  - `ended_at` (TIMESTAMPTZ).
  - `status` (VARCHAR(16) NOT NULL): `active`, `completed`, `abandoned`.
* **`learning_events`**:
  - `id` (UUID PK): Client-generated UUID for idempotency.
  - `school_id` (UUID NOT NULL FK `schools.id`).
  - `session_id` (UUID NOT NULL FK `learning_sessions.id`).
  - `student_id` (UUID NOT NULL FK `student_profiles.id`).
  - `concept_id` (VARCHAR(128) NOT NULL).
  - `item_id` (VARCHAR(128) NOT NULL).
  - `attempt_number` (INT NOT NULL DEFAULT 1).
  - `is_correct` (BOOLEAN NOT NULL).
  - `assistance_level` (INT NOT NULL DEFAULT 0): 0 to 8.
  - `response_time_ms` (INT NOT NULL).
  - `verification_source` (VARCHAR(64) NOT NULL): `symbolic_math_check`, `answer_key`, `teacher`.
  - `relayed_to_lam` (BOOLEAN NOT NULL DEFAULT FALSE): Tracked delivery status.
  - `relayed_at` (TIMESTAMPTZ).
  - `created_at` (TIMESTAMPTZ NOT NULL DEFAULT NOW()).
