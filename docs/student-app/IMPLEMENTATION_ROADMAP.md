# Qrie Student App — Phased Implementation Roadmap

**Document Reference:** `docs/student-app/IMPLEMENTATION_ROADMAP.md`  
**Status:** Approved Roadmap  
**Author:** Principal Engineering Program Lead  

---

## Roadmap Timeline Overview

```
Phase 0 ──► Phase 1 ──► Phase 2 ──► Phase 3 ──► Phase 4 ──► Phase 5 ──► Phase 6 ──► Phase 7 ──► Phase 8
 Audit       PRD & Spec  Foundation   Curriculum   Practice     LAM Recs     Review       Offline      Release
 (Done)      (Done)      & Auth       & Lessons    & Solver     Integration  & Progress   Sync Outbox  Hardening
```

---

## Detailed Milestone Execution

### Phase 0: System & Repository Audit
- **Status:** ✅ **COMPLETED**
- **Deliverables:** `PROJECT_AUDIT.md`, verified repository boundaries, verified LAM contracts, database migration inventory.

### Phase 1: Product Requirements & Technical Contracts
- **Status:** ✅ **COMPLETED**
- **Deliverables:** `STUDENT_APP_PRD.md`, `SCREEN_SPECIFICATION.md`, `USER_JOURNEYS.md`, `NAVIGATION_MAP.md`, `API_INTEGRATION_SPEC.md`, `DATA_MODEL_SPEC.md`.

---

### Phase 2: Flutter Foundation, Theme, Routing & Authentication
- **Objective:** Establish the clean architecture foundation with Duolingo design system, GoRouter, and secure session management.
- **Tasks:**
  1. Initialize feature-first directory layout under `android-app/qrie/lib/`.
  2. Implement `AppColors`, `AppTypography` (Nunito), and `AppTheme`.
  3. Build reusable Duolingo components: `DuolingoButton` (3D sticker), `MascotAvatar`, `DuolingoProgressBar`, `TopNavigationBar`.
  4. Configure `GoRouter` with auth guards and bottom-bar `StatefulShellRoute`.
  5. Implement `AuthService` connecting to `POST /api/v1/auth/session` and `POST /api/v1/auth/login`.
- **Dependencies:** None.
- **Completion Criteria:** Student can launch app, enter credentials, and land on persistent home shell with zero overflow on 360dp screens.

---

### Phase 3: Curriculum Discovery & Interactive Lessons
- **Objective:** Render dynamic NCERT curriculum hierarchy and storybook visual lessons.
- **Tasks:**
  1. Add Fastify backend endpoints: `GET /curriculum/subjects` and `GET /curriculum/chapters`.
  2. Implement `CurriculumRepository` with local SQLite memory caching.
  3. Build SCR-05 (Subject Browser) and SCR-06 (Vertical Gamified Node Roadmap).
  4. Build SCR-07 (Lesson Viewer) supporting SVG diagrams, key takeaways, and formulas.
- **Dependencies:** Phase 2.
- **Completion Criteria:** Student can browse Class 8 Science chapters and view the Mitochondria lesson with interactive diagrams.

---

### Phase 4: Practice Zone & Authoritative Verification
- **Objective:** Deliver interactive practice with server-verified correctness and Duolingo feedback.
- **Tasks:**
  1. Implement backend endpoint `POST /learning/sessions/start` and `POST /learning/sessions/:id/attempt`.
  2. Build SCR-08 (Adaptive Practice Solver) supporting single-choice and numeric questions.
  3. Implement Duolingo bottom evaluation sheets (Green celebration vs Coral hint prompt).
  4. Build Rungs 1, 2, and 5 scaffolding presentation in SCR-09.
- **Dependencies:** Phase 3.
- **Completion Criteria:** Practice attempts are verified by the backend, XP is awarded, and incorrect answers trigger gentle rethink scaffolding.

---

### Phase 5: Trusted LAM Recommendation Integration
- **Objective:** Deliver autonomous next-step learning recommendations from LAM.
- **Tasks:**
  1. Wire Fastify endpoint `GET /learning/recommendations` to `LamAdapterClient.getRecommendation`.
  2. Build recommendation cards on SCR-04 (Home) displaying pedagogical rationale.
  3. Verify circuit breaker fallback engagement when LAM service is paused.
- **Dependencies:** Phase 4, LAM running locally or via mock.
- **Completion Criteria:** Home screen displays personalized next practice recommendation with safe fallback if LAM is unreachable.

---

### Phase 6: Spaced Retrieval Review & Progress Dashboard
- **Objective:** Help students retain learned concepts through spaced repetition.
- **Tasks:**
  1. Implement `GET /learning/reviews/due` in Fastify backend calling LAM reviews endpoint.
  2. Build SCR-10 (Spaced Retrieval Due Queue).
  3. Build SCR-11 (Progress Dashboard) displaying unassisted vs assisted mastery and weekly study hours chart.
  4. Implement badge unlocking room.
- **Dependencies:** Phase 5.
- **Completion Criteria:** Due review items appear at decaying half-life intervals; progress screen accurately separates unassisted vs assisted mastery.

---

### Phase 7: Offline Outbox & Background Synchronization
- **Objective:** Guarantee zero lost data during network dropouts.
- **Tasks:**
  1. Implement Drift `sync_outbox` table and client-minted UUID event generator.
  2. Build `OutboxSyncWorker` with connectivity stream listener and exponential backoff retry.
  3. Implement backend batch ingestion endpoint `POST /sync/events`.
- **Dependencies:** Phase 6.
- **Completion Criteria:** 50 questions answered offline in airplane mode successfully synchronize on reconnect with 0 duplicates.

---

### Phase 8: Hardening, Accessibility & Release Readiness
- **Objective:** Comprehensive testing on physical Android devices.
- **Tasks:**
  1. Execute accessibility audit on TalkBack screen reader (100% compliant).
  2. Validate performance on entry-level Android devices (Moto G, Redmi 2GB RAM).
  3. Run full automated integration test suite (`flutter test integration_test/`).
  4. Generate signed release APK / AAB.
- **Dependencies:** Phase 7.
- **Completion Criteria:** Zero critical security or memory issues; smooth $\ge 55\text{ FPS}$ performance; release candidate approved.
