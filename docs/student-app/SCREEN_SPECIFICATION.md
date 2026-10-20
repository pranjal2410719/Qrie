# Qrie Student App — Screen & Component Specifications

**Document Reference:** `docs/student-app/SCREEN_SPECIFICATION.md`  
**Status:** Approved Specification  
**Author:** Principal UX Designer & Senior Flutter Engineer  

---

## Screen Inventory Overview

| Screen ID | Screen Name | Route Path | Primary User Goal |
| :--- | :--- | :--- | :--- |
| **SCR-01** | Splash & Environment Init | `/splash` | Validate token, check network, restore session |
| **SCR-02** | Sign-In & Auth | `/auth/login` | Authenticate student via Supabase session |
| **SCR-03** | School / Class Code | `/auth/enroll` | Enter school code to join classroom roster |
| **SCR-04** | Student Home | `/home` | View daily goals, resume lesson, recommended next step |
| **SCR-05** | Curriculum Browser | `/curriculum` | Browse subjects and chapters for enrolled grade |
| **SCR-06** | Chapter Concept Map | `/curriculum/:chapterId` | View prerequisite concept nodes and roadmap |
| **SCR-07** | Interactive Lesson View | `/lesson/:lessonId` | Read concept narrative, inspect diagrams, do checks |
| **SCR-08** | Adaptive Practice Zone | `/practice/:sessionId` | Solve questions, receive instant server verification |
| **SCR-09** | Assistance Scaffolding | Modal over SCR-08 | Receive stepped hints (Rethink, Hint, Worked Example) |
| **SCR-10** | Spaced Retrieval Review | `/review` | Practice due retrieval items to consolidate memory |
| **SCR-11** | Progress & Mastery | `/progress` | Review unassisted vs assisted concept mastery |
| **SCR-12** | Profile & Settings | `/profile` | Manage accessibility, offline cache, sign-out |

---

## Detailed Specifications

### SCR-01: Splash & Environment Initialization
- **Goal:** Verify local session tokens, check server readiness, and route to Home or Login within 1.5 seconds.
- **Entry Route:** App launch.
- **Layout & Components:**
  - Centered Qrie logo with subtle breathing animation.
  - Minimalist brand spinner below.
  - Version identifier footer (`v1.0.0 (build 1)`).
- **Data & APIs:**
  - Read `auth_token` and `refresh_token` from `flutter_secure_storage`.
  - `GET /health/live` to verify backend reachability.
  - `POST /api/v1/auth/session` if token exists.
- **States:**
  - *Network Unavailable:* If offline and token exists, transition directly to `/home` in offline mode.
  - *Token Expired & Refresh Failed:* Transition to `/auth/login`.
- **Accessibility:** Screen reader announces: "Qrie AI, loading your learning environment."

---

### SCR-02: Sign-In & Authentication
- **Goal:** Secure, student-friendly sign-in with email or student ID.
- **Entry Route:** `/auth/login`.
- **Layout & Components:**
  - Top illustrated mascot banner ("Welcome back to learning!").
  - Form fields: Student Email / Roll Number, Password.
  - 3D tactile button: `SIGN IN` (Green fill, 12px radius, bottom depth shadow).
  - Outlined button: `I HAVE A SCHOOL CODE` (Navigates to SCR-03).
- **APIs:** `POST /api/v1/auth/login`.
- **Error Handling:** RFC 7807 error alert banner for invalid credentials or suspended tenant.

---

### SCR-03: School Enrollment & Class Code
- **Goal:** Link a student account to a school organization using a 6-character code (e.g., `DEL-8B`).
- **Entry Route:** `/auth/enroll`.
- **Layout & Components:**
  - Visual explanation: "Enter the code provided by your school teacher."
  - 6-box formatted OTP-style text entry with uppercase formatting.
  - Auto-detected school name confirmation card upon valid code prefix.
  - 3D button: `CONFIRM & JOIN CLASS`.
- **APIs:** `POST /api/v1/auth/enroll`.

---

### SCR-04: Student Home Dashboard
- **Goal:** Clear orientation: see daily goal, continue recent lesson, and launch recommended practice.
- **Entry Route:** `/home`.
- **Layout Hierarchy:**
  ```text
  TopNavigationBar (Grade Pill 'CLASS 8 CBSE ▾', Streak 🔥, Gems 💎, Mascot)
  ├── DailyGoalProgressCard (Pill progress bar with 2/3 lessons done)
  ├── SubjectSelectorHorizontalList (Science, Mathematics, Social Studies)
  ├── HeroContinueLearningCard (Topic Title, Duration, 3D 'RESUME LESSON' CTA)
  ├── NextRecommendedActivityCard (LAM Tiered recommendation with rationale)
  └── DueRetrievalAlertCard (Spaced review items due today, 'REVISE NOW' CTA)
  ```
- **Data & APIs:**
  - `GET /api/v1/student/dashboard`
  - `GET /api/v1/learning/recommendations`
- **States:**
  - *Offline:* Banner shows "Offline mode — practicing saved topics".
  - *No recommendation:* Fallback to next syllabus topic.

---

### SCR-05: Curriculum & Subject Browser
- **Goal:** Browse all subjects and chapters for the student's current grade (e.g. Class 8).
- **Entry Route:** `/curriculum`.
- **Layout Hierarchy:**
  - Grade context banner (`NCERT Class 8 Curriculum`).
  - Subject cards grid (Mathematics, Science, Social Studies).
  - Each subject card shows: Icon emoji, Chapter count, Progress bar (0–100%), and Completed badge count.
- **Data & APIs:** `GET /api/v1/curriculum/subjects?grade=8`.

---

### SCR-06: Chapter Concept Map & Roadmap
- **Goal:** Understand chapter structure as a connected gamified dependency path.
- **Entry Route:** `/curriculum/:chapterId`.
- **Layout Hierarchy:**
  - Chapter title header (`Chapter 1: Cell — Structure & Functions`).
  - Vertical node roadmap with connected SVG connector paths.
  - Node types:
    - *Completed:* Green circle with checkmark.
    - *Current Active:* Pulsating ring with floating `START! ⭐` sticker badge.
    - *Locked:* Gray circle with padlock (prerequisites not met).
    - *Boss Challenge:* Gold trophy icon for chapter diagnostic.
- **Data & APIs:** `GET /api/v1/curriculum/chapters/:chapterId/concepts`.

---

### SCR-07: Interactive Lesson Viewer
- **Goal:** Read concept narrative, inspect labeled diagrams, and complete in-lesson checkpoints.
- **Entry Route:** `/lesson/:lessonId`.
- **Layout Hierarchy:**
  - Top bar with back button, bookmark icon, and lesson title.
  - Duration pill (`9 MINS`) and XP reward badge (`+30 XP`).
  - Concept visual area: Interactive diagram viewer with pan/zoom.
  - Storybook text section: Clean typography, key formulas highlighted in boxes.
  - Checklist of core takeaways with green check stickers.
  - Qrie mascot callout box ("Did You Know?").
  - Fixed bottom bar: `TAKE CONCEPT QUIZ` (Duolingo 3D button).
- **Data & APIs:** `GET /api/v1/curriculum/lessons/:lessonId`.

---

### SCR-08: Adaptive Practice Zone & Question Solver
- **Goal:** Answer questions independently, receive verified feedback, and build mastery.
- **Entry Route:** `/practice/:sessionId`.
- **Layout Hierarchy:**
  - Top Bar: Close 'X' button, Duolingo linear progress bar with glossy highlight, streak counter.
  - Mascot dialogue prompt: Speech bubble asking the question or encouraging the student.
  - Question Card: Formatted question statement with KaTeX math rendering support.
  - Multiple Choice Options: Tactile 3D cards with 2.5px borders and selection state.
  - Bottom Action: Disabled until selection, then vibrant green `CHECK` button.
  - Evaluation Bottom Sheet:
    - *Correct:* Storybook green wash (`#D7FFB8`), dark green text ("Nicely done! 🎉"), explanation, `CONTINUE` CTA.
    - *Incorrect:* Soft coral wash (`#FFDFDF`), explanation of step error, `REQUEST HINT` or `GOT IT` CTA.
- **Data & APIs:**
  - `POST /api/v1/learning/sessions/:sessionId/attempt`
- **Telemetry:** Captures `active_ms`, `attempt_number`, `response_time_ms`, and `assistance_level`.

---

### SCR-09: Assistance Modal (9-Level Scaffolding)
- **Goal:** Provide graduated help that encourages reasoning without revealing answers.
- **Entry Route:** Triggered from SCR-08 when student requests help or after repeated mistakes.
- **Components:**
  - Mascot in "Thinking" mood.
  - Scaffolding Level Header:
    - *Level 1 (Rethink):* "Look closely at the formula units."
    - *Level 2 (Strategic Hint):* "Recall that $P = F / A$. What happens when area decreases?"
    - *Level 5 (Worked Example):* Walkthrough of an analogous problem with different numbers.
  - Action: `TRY PROBLEM AGAIN` (returns to solver without penalty).

---

### SCR-10: Spaced Retrieval Review
- **Goal:** Practice due concepts to prevent memory decay.
- **Entry Route:** `/review`.
- **Layout Hierarchy:**
  - Memory strength indicator ("Concepts needing a memory refresh").
  - Due cards list organized by urgency: Critical Overdue, Due Today, Due Soon.
  - Action: `START 5-MINUTE REVISION SPRINT`.
- **Data & APIs:** `GET /api/v1/learning/reviews/due`.

---

### SCR-11: Progress & Mastery Dashboard
- **Goal:** Transparent view of learning progress without misleading score claims.
- **Entry Route:** `/progress`.
- **Layout Hierarchy:**
  - Total XP, Day Streak, and Lessons Completed summary cards.
  - Weekly study time chart: Mon–Sun vertical bar chart with daily hours.
  - Topic Mastery Grid:
    - *Unassisted Mastery:* Green meter indicating verified independent success.
    - *Assisted Performance:* Blue meter showing success achieved with hints.
  - Badges Room: Unlocked badges in full color; locked badges with padlock and requirement description.
- **Data & APIs:** `GET /api/v1/student/progress`.

---

### SCR-12: Student Profile & Settings
- **Goal:** Manage grade preferences, accessibility, cache storage, and session termination.
- **Entry Route:** `/profile`.
- **Layout Components:**
  - Student identity card (Name, Class, Roll Number, School Tenant).
  - Academic preferences: Switch Grade (6–10) and Board (CBSE/ICSE).
  - Accessibility settings: Text scale slider, high-contrast toggle, reduced motion toggle.
  - Offline cache manager: Cache size indicator with `CLEAR CACHED LESSONS` button.
  - `SIGN OUT` button with session cleanup confirmation.
