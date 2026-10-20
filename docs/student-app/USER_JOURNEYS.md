# Qrie Student App — User Journeys & Flowcharts

**Document Reference:** `docs/student-app/USER_JOURNEYS.md`  
**Status:** Approved Specification  
**Author:** Principal UX Architect & Flow Designer  

---

## Journey A: First-Time Student Onboarding & Enrollment

```mermaid
flowchart TD
    Start([App Launch]) --> CheckToken{Local Token Exists?}
    CheckToken -- No --> Welcome[SCR-02: Welcome & Sign-In Screen]
    Welcome --> EnterCreds[Student Enters Credentials or Joins via School Code]
    EnterCreds --> SubmitAuth[POST /api/v1/auth/login]
    
    SubmitAuth -- Success --> CheckSchool{Belongs to School Org?}
    CheckSchool -- No --> EnrollCode[SCR-03: Enter 6-Digit School/Class Code]
    EnrollCode --> SubmitEnroll[POST /api/v1/auth/enroll]
    SubmitEnroll --> SaveToken[Securely Persist JWT & School ID]
    CheckSchool -- Yes --> SaveToken
    
    SaveToken --> FetchCurriculum[Fetch Initial Class Syllabus]
    FetchCurriculum --> ShowHome[SCR-04: Student Home Dashboard]
    ShowHome --> Done([Ready to Learn])
```

---

## Journey B: Returning Student Session Resume

```mermaid
flowchart TD
    Launch([App Launch]) --> ReadSecure[Read JWT from Secure Storage]
    ReadSecure --> HasToken{Token Present?}
    HasToken -- Yes --> PingBackend[GET /health/live]
    
    PingBackend -- Online --> VerifySession[POST /api/v1/auth/session]
    VerifySession -- Valid Session --> FetchDash[GET /api/v1/student/dashboard]
    FetchDash --> OpenHome[SCR-04: Home Screen with Resume Card]
    
    PingBackend -- Offline --> LoadLocalCache[Load Cached Student Profile & Lessons]
    LoadLocalCache --> OpenOfflineHome[SCR-04: Home Screen in Offline Mode]
    
    VerifySession -- Expired/Invalid --> RefreshAttempt{Refresh Token Valid?}
    RefreshAttempt -- Yes --> GetNewToken[Exchange for New Access Token] --> FetchDash
    RefreshAttempt -- No --> GoLogin[SCR-02: Sign-In Screen with Session Expired Notice]
```

---

## Journey C: Independent Curriculum Practice & Verification

```mermaid
sequenceDiagram
    autonumber
    actor Student as Student (Flutter App)
    participant Backend as Qrie Backend (Fastify)
    participant DB as Postgres Ledger
    participant LAM as LAM Engine (Python)

    Student->>Backend: POST /api/v1/learning/sessions/start {concept_id, subject}
    Backend->>DB: INSERT INTO learning_session (status: 'active')
    Backend-->>Student: 201 Created {session_id, items: [Item1, Item2, ...]}
    
    Student->>Student: Solves Item 1 on SCR-08 (records active_ms & response_time)
    Student->>Backend: POST /api/v1/learning/sessions/:id/attempt {item_id, answer, time_ms}
    
    Note over Backend: Server-Side Authoritative Verification
    Backend->>Backend: Validate answer against answer key / symbolic checker
    Backend->>DB: INSERT INTO learning_events (is_correct, attempt_num, active_ms)
    
    opt Async Relay to LAM
        Backend->>LAM: POST /v1/events (signed JWT)
        LAM->>LAM: Run BKT Mastery Update atomically
    end

    Backend-->>Student: 200 OK {is_correct: true, explanation: "...", xp_earned: 20}
    Student->>Student: Displays Green Duolingo Evaluation Banner & XP counter
```

---

## Journey D: Incorrect Answer & Adaptive Assistance Escalation

```mermaid
flowchart TD
    SubmitAnswer[Student Submits Answer on SCR-08] --> ServerCheck{Server Verification}
    ServerCheck -- Correct --> GreenBanner[Display Storybook Green Banner: 'Nicely done!']
    
    ServerCheck -- Incorrect --> AttemptCount{Attempt Number?}
    AttemptCount -- Attempt 1 --> SoftPrompt[Display Coral Banner with Rethink Cue: 'Check units']
    SoftPrompt --> Retry1[Student Taps 'TRY AGAIN']
    
    AttemptCount -- Attempt 2 --> OfferHint[Display Hint Button: 'Need a hint?']
    OfferHint --> StudentHintChoice{Student Taps Hint?}
    StudentHintChoice -- No --> Retry2[Second Attempt]
    StudentHintChoice -- Yes --> RequestRung2[SCR-09: Show Rung 2 Strategic Scaffolding]
    RequestRung2 --> LogAssisted[Flag Attempt as Assisted] --> Retry2
    
    AttemptCount -- Attempt 3+ --> ShowWorkedExample[SCR-09: Present Rung 5 Analogous Worked Example]
    ShowWorkedExample --> ReVerify[Present Fresh Isomorphic Practice Question]
```

---

## Journey E: Adaptive Recommendation & Next Activity

```mermaid
flowchart TD
    FinishLesson[Student Finishes Lesson or Quiz] --> ReqRec[GET /api/v1/learning/recommendations]
    ReqRec --> BackendCheck{Backend Calls LAM}
    
    BackendCheck -- LAM Available --> EvalTiers[LAM Evaluates 6-Tier Policy]
    EvalTiers --> ReturnRec[Return Recommendation: target_concept, rationale, priority]
    
    BackendCheck -- LAM Timeout/Down --> FallbackRec[Engage Circuit Breaker: Deterministic Next Syllabus Topic]
    
    ReturnRec --> DisplayRecCard[SCR-04: Hero Card Highlights Recommended Next Step]
    FallbackRec --> DisplayRecCard
    DisplayRecCard --> StudentTap[Student Taps 'START RECOMMENDED PRACTICE']
    StudentTap --> LaunchSession[Open SCR-08 Practice Session]
```

---

## Journey F: Offline Mode, Durable Outbox & Reconnect Sync

```mermaid
sequenceDiagram
    autonumber
    actor Student as Student Device
    participant LocalDB as Local SQLite / Drift (Outbox)
    participant NetWatcher as Network State Stream
    participant Backend as Qrie Backend

    Note over Student: Network Drops (Offline)
    Student->>LocalDB: Read cached lesson / practice item
    Student->>Student: Solves question offline
    Student->>LocalDB: INSERT INTO offline_outbox (client_event_id, session_id, answer, timestamp)
    Student->>Student: Display: "Saved offline. Will sync when back online."

    Note over NetWatcher: Network Reconnected (Wi-Fi / 4G)
    NetWatcher->>Student: Trigger Background Sync Job
    Student->>LocalDB: Fetch pending events ordered by timestamp
    
    loop For Each Pending Batch
        Student->>Backend: POST /api/v1/sync/events {events: [...]}
        Note over Backend: Idempotent Ledger Ingestion (ON CONFLICT id DO NOTHING)
        Backend-->>Student: 200 OK {synced_ids: [...], duplicate_ids: [...]}
        Student->>LocalDB: DELETE FROM offline_outbox WHERE id IN (synced_ids)
    end
    
    Student->>Student: Update UI: "All offline work synchronized!"
```

---

## Journey G: Session Interruption & Crash Recovery

```mermaid
flowchart TD
    ActiveSession[Student Mid-Way Through Practice SCR-08] --> AppInterrupted[App Terminated / Phone Call / Low Battery]
    AppInterrupted --> LocalSave[Local Lifecycle Hook Saves: current_index, session_id, answers]
    
    AppRestart[Student Re-opens App Later] --> DetectPending[Detect Incomplete Session in Local DB]
    DetectPending --> PromptResume{Show Modal: 'Resume Practice?'}
    PromptResume -- Resume --> RestoreState[Restore Questions & Index on SCR-08]
    PromptResume -- Discard --> MarkAbandoned[Mark Session Abandoned locally & Inform Server]
```

---

## Journey H: Session Expiry & Safe Re-Authentication

```mermaid
flowchart TD
    ProtectedCall[Student Action Triggers API Request] --> Backend401{Backend Returns 401 Unauthorized}
    Backend401 --> Interceptor[Flutter Dio/Http Auth Interceptor Catches 401]
    Interceptor --> TryRefresh[Attempt Token Refresh with Refresh Token]
    
    TryRefresh -- Refresh Success --> SaveNewToken[Save New JWT to Secure Storage]
    SaveNewToken --> RetryOriginal[Re-execute Original Pending Request]
    
    TryRefresh -- Refresh Failure/Expired --> ClearSensitive[Wipe Secure In-Memory Session]
    ClearSensitive --> RedirectLogin[Redirect to SCR-02: 'Session Expired, Please Sign In']
    RedirectLogin --> ReAuth[Student Signs In] --> RestoreContext[Return to Previous Route]
```
