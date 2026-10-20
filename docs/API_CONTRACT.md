# Qrie AI — Application Backend API Contract (v1)

Base URL: `http://localhost:4000/api/v1` (or `https://api.qrie.internal/api/v1`)  
Authentication: `Authorization: Bearer <JWT>`

---

## 1. System Health
* `GET /health/live`  
  Returns service liveness: `{"status": "alive"}`
* `GET /health/ready`  
  Returns database and LAM adapter connectivity:
  `{"status": "ready", "database": "connected", "lam_relay": "healthy"}`

---

## 2. Authentication & Profile
* `POST /auth/session`  
  Exchanges/validates Supabase token, returns session identity, roles, and school membership.
  ```json
  {
    "user_id": "usr_94f8a3c1",
    "email": "teacher@dps.edu.in",
    "role": "teacher",
    "school_id": "sch_dps_delhi",
    "full_name": "Dr. Ananya Sharma"
  }
  ```

---

## 3. Teacher Portal APIs (`/teacher/...`)
* `GET /teacher/classes`  
  Returns classes assigned to the authenticated teacher.
* `GET /teacher/classes/{class_id}/students`  
  Returns students enrolled in the class with their struggle alerts and recent activity.
* `GET /teacher/classes/{class_id}/mastery-summary`  
  Aggregated topic strengths and learning difficulties.

---

## 4. Admin Portal APIs (`/admin/...`)
* `GET /admin/school`  
  Returns school metadata, student count, teacher count, class count.
* `POST /admin/classes`  
  Creates a new class section.
* `POST /admin/students`  
  Enrolls a new student.
* `POST /admin/teachers`  
  Invites or provisions a teacher profile.

---

## 5. Learning Sessions & Telemetry (`/learning/...`)
* `POST /learning/sessions/start`  
  Starts a learning session for a student.
* `POST /learning/sessions/{session_id}/attempt`  
  Submits student answer, executes server-side verification, records event in local DB, asynchronously notifies LAM, and returns feedback + immediate next action recommendation from LAM.
