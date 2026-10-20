# Qrie Student Application — Product Requirements Document (PRD)

**Document Reference:** `docs/student-app/STUDENT_APP_PRD.md`  
**Status:** Approved Specification  
**Author:** Principal Product Architect & Learning Science Specialist  
**Target Release:** Android MVP  

---

## 1. Problem Statement & Executive Vision

### 1.1 The Problem
Indian school students in Classes 6–12 preparing for NCERT-aligned school and board examinations face three critical learning challenges:
1. **Passive Consumption without Verification:** Traditional video apps promote passive watching without immediate, authoritative verification of conceptual understanding.
2. **Punitive and Opaque Assessment:** Incorrect answers are treated as failure rather than diagnostic signals, inducing math and science anxiety.
3. **Fragile Memory & Cramming:** Concepts taught in July are forgotten by November due to lack of systematically scheduled spaced retrieval.

### 1.2 The Vision
**Qrie Student App** is an autonomous, low-bandwidth, Android-first learning companion that provides:
- **Active Conceptual Learning:** Bite-sized interactive lessons with live checkpoints.
- **Supportive 9-Rung Assistance:** When a student struggles, the app provides graduated scaffolding (rethink prompt ➔ strategic hint ➔ scaffolded substep ➔ worked example) rather than prematurely giving away answers.
- **LAM-Powered Retrieval:** Autonomous spaced practice based on decaying memory strength.
- **Unassisted Mastery Focus:** Celebrating independent student success over assisted completions.

---

## 2. Target Personas & Context Constraints

```
┌────────────────────────────────────────────────────────────────────────┐
│                        STUDENT PERSONAS MATRIX                         │
├───────────────┬────────────────────────┬───────────────────────────────┤
│ Persona Group │ Cognitive Needs        │ Technical Context             │
├───────────────┼────────────────────────┼───────────────────────────────┤
│ Classes 6–8   │ Concrete visual models,│ Shared family phone, Android  │
│ (Middle)      │ story-driven anchors,  │ 10–12, 2GB–3GB RAM, spotty    │
│               │ playful mascot support │ home Wi-Fi or prepaid 4G      │
├───────────────┼────────────────────────┼───────────────────────────────┤
│ Classes 9–10  │ Rigorous board exam    │ Personal or shared mobile,    │
│ (Secondary)   │ precision, step proofs,│ 720p screen, intermittent     │
│               │ misconception diagnosis│ evening connectivity          │
├───────────────┼────────────────────────┼───────────────────────────────┤
│ Classes 11–12 │ Deep conceptual depth, │ Dedicated phone, intensive    │
│ (Senior)      │ multi-concept linkage, │ daily practice, offline       │
│               │ speed & accuracy pacing│ study during commutes         │
└───────────────┴────────────────────────┴───────────────────────────────┘
```

### Technical Device Constraints
- **Minimum OS:** Android 8.0 (API 26); Target Android 14+ (API 34+).
- **RAM Footprint:** Maximum 120MB active memory; graceful operation on 2GB RAM devices.
- **Storage Footprint:** Maximum 45MB download size; offline cache budget capped at 150MB.
- **Network Resilience:** Seamless offline queuing of practice events; low-bandwidth fallback when network latency exceeds 3,000ms.

---

## 3. Scope Matrix

### 3.1 MVP (Minimum Viable Product)
- **Launch & Session:** Seamless session restoration, school/solo tenant context, offline readiness.
- **Curriculum Exploration:** NCERT curriculum tree (Classes 6–10 Mathematics & Science), chapter/topic navigation.
- **Interactive Lessons:** Rich lesson view with concept explanations, worked examples, and check questions.
- **Practice & Instant Evaluation:** Multiple-choice and numeric questions with server-verified correctness.
- **Assistance Ladder:** Presentation of backend-approved hints (Rung 1 rethink, Rung 2 strategic hint, Rung 5 worked example).
- **Spaced Review Due Queue:** Listing due retrieval cards scheduled by LAM.
- **Student Progress Summary:** Clear visualization of unassisted vs assisted mastery per concept.
- **Durable Offline Outbox:** Storing practice attempts locally and syncing idempotently on reconnect.

### 3.2 V1 (Post-MVP Enhancements)
- Symbolic mathematical formula input using KaTeX / LaTeX mobile rendering.
- Offline downloadable lesson bundles for full chapters.
- Full 9-rung assistance engine presentation including interactive substeps.
- Audio pronunciation and bilingual Hindi/English terminology support.
- Push notifications for scheduled review reminders (strictly respecting school quiet hours).

### 3.3 Out of Scope
- Teacher grading workflows (owned by Teacher Web Portal).
- Student roster and class assignment provisioning (owned by Admin Portal).
- Authoritative mastery model calculation (owned strictly by LAM).
- Social feeds, open chatrooms, or public student leaderboards (preventing social comparison anxiety and child safety risks).

---

## 4. Key Performance Indicators & Educational Metrics

1. **Primary North Star:** **Unassisted Mastery Gain per Learning Minute (UMG/LM)**
   - Measured as change in unassisted mastery ($L_0$ to 0.85 threshold) divided by verified active task time (`active_ms`).
2. **Assistance Efficiency:** Ratio of students who succeed independently on item $N+1$ after receiving a Rung 1 or Rung 2 hint on item $N$.
3. **Retrieval Retention Rate:** Percentage of spaced review questions answered correctly on first attempt at 3-day and 7-day intervals.
4. **Offline Sync Reliability:** 100% deduplication and zero lost interaction events upon network restoration.
