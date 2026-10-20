# Qrie Student App — Navigation Map & Routing Specification

**Document Reference:** `docs/student-app/NAVIGATION_MAP.md`  
**Status:** Approved Specification  
**Author:** Senior Flutter Engineer & Router Architect  

---

## 1. Top-Level Route Hierarchy

The application utilizes a declarative router (`go_router`) with a persistent `StatefulShellRoute` preserving bottom-bar tab state across navigation events.

```
/ (Root)
│
├── /splash (SCR-01: Initialization & Session Guard)
│
├── /auth (Authentication Flow)
│   ├── /auth/login (SCR-02: Sign In)
│   └── /auth/enroll (SCR-03: School Code Flow)
│
└── /main (StatefulShellRoute with Persistent Bottom Navigation)
    │
    ├── /home (Tab 0: SCR-04 Student Dashboard)
    │
    ├── /curriculum (Tab 1: SCR-05 Subject Browser)
    │   └── /curriculum/:chapterId (SCR-06 Chapter Concept Roadmap)
    │
    ├── /practice (Tab 2: Adaptive Practice Zone)
    │   └── /practice/session/:sessionId (SCR-08 Question Solver)
    │
    ├── /review (Tab 3: SCR-10 Spaced Retrieval Due List)
    │
    └── /profile (Tab 4: SCR-12 Profile & Settings)
        └── /profile/progress (SCR-11 Detailed Mastery & Badge Room)

Standalone Full-Screen Modals:
├── /lesson/:lessonId (SCR-07 Interactive Lesson Viewer)
└── /practice/solver/:sessionId (SCR-08 Fullscreen Focused Quiz)
```

---

## 2. Route Guard Matrix

```
┌─────────────────┬───────────────────────┬──────────────────────────────────────────┐
│ Route Path      │ Guard Requirements    │ Redirect Destination if Denied           │
├─────────────────┼───────────────────────┼──────────────────────────────────────────┤
│ `/splash`       │ None                  │ Unconditional entry                      │
├─────────────────┼───────────────────────┼──────────────────────────────────────────┤
│ `/auth/*`       │ Unauthenticated Only  │ If valid session exists ➔ `/home`        │
├─────────────────┼───────────────────────┼──────────────────────────────────────────┤
│ `/main/*`       │ Valid Session + Role  │ If no token ➔ `/auth/login`              │
│                 │ (`role == 'student'`) │ If not student role ➔ `/auth/unauthorized│
├─────────────────┼───────────────────────┼──────────────────────────────────────────┤
│ `/lesson/:id`   │ Authenticated +       │ If offline and un-cached ➔ Dialog prompt │
│                 │ Cache Check           │                                          │
├─────────────────┼───────────────────────┼──────────────────────────────────────────┤
│ `/practice/:id` │ Active Session Valid  │ If session completed ➔ `/home`           │
└─────────────────┴───────────────────────┴──────────────────────────────────────────┘
```

---

## 3. Back-Stack & Navigation Rules

1. **Root Exit Prevention:** Pressing Android system back on any primary tab (`/home`, `/curriculum`, `/practice`, `/review`, `/profile`) when not on `/home` navigates back to `/home` (Tab 0). Pressing back on `/home` shows a standard double-back-tap confirmation toast ("Press back again to exit Qrie").
2. **Practice Interruption Protection:** In `/practice/session/:sessionId`, pressing back or close displays an exit confirmation modal:
   - *"Pause and save progress for later?"*
   - Options: `SAVE & EXIT` (commits `active_ms` to local ledger) or `CANCEL`.
3. **Deep Link Handling:**
   - Universal Link: `https://learn.qrie.ai/lesson/:lessonId` ➔ Resolves token; if valid, pushes lesson viewer with back-arrow leading to `/curriculum`.
   - School Join Link: `https://learn.qrie.ai/join?code=DEL-8B` ➔ Pre-fills enrollment code in SCR-03.
