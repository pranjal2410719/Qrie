# Qrie Student App — Testing Strategy & Acceptance Criteria

**Document Reference:** `docs/student-app/TESTING_ACCEPTANCE_CRITERIA.md`  
**Status:** Approved Specification  
**Author:** QA Lead & Senior Test Automation Engineer  

---

## 1. Testing Pyramid & Test Types

```
               / \
              /   \
             / E2E \       10% End-to-End User Flow Tests (IntegrationTest)
            /-------\
           / Widget  \     30% Screen & State Snapshot Tests (WidgetTester)
          /-----------\
         /  Unit Tests \   60% Domain Logic, BKT Mappings & Serialization
        /---------------\
```

---

## 2. Measurable Acceptance Criteria by Module

### 2.1 Authentication & Multi-Tenancy
- [ ] **AC-AUTH-01:** An unauthenticated user cannot navigate past `/splash` to any `/main/*` route.
- [ ] **AC-AUTH-02:** Upon entering invalid credentials, the app presents an understandable error message parsed from RFC 7807 problem details without crashing or displaying stack traces.
- [ ] **AC-AUTH-03:** The student JWT is saved exclusively in encrypted storage (`flutter_secure_storage`).
- [ ] **AC-AUTH-04:** Attempting to query resources with a mismatched `school_id` receives a `403 Forbidden` response and displays: *"You do not have permission to view content from another school."*

### 2.2 Curriculum & Interactive Lessons
- [ ] **AC-CURR-01:** Subjects, chapters, and concepts are dynamically populated from verified NCERT metadata matching the student's enrolled grade.
- [ ] **AC-CURR-02:** Locked chapters display a clear prerequisite requirement label (e.g. *"Complete Linear Equations 1.1 first"*).
- [ ] **AC-CURR-03:** Lessons render text narratives, SVG diagrams, and formula cards without text clipping or layout overflow under $200\%$ system font scale.

### 2.3 Practice & Authoritative Verification
- [ ] **AC-PRAC-01:** An option card can be toggled; the `CHECK` button is disabled until an option is selected.
- [ ] **AC-PRAC-02:** Correctness feedback is displayed **only** after receiving a verified server response from `POST /api/v1/learning/sessions/:id/attempt`.
- [ ] **AC-PRAC-03:** A correct answer displays the Storybook Green evaluation sheet, chimes pleasant feedback, and awards verified XP.
- [ ] **AC-PRAC-04:** An incorrect answer on attempt 1 displays a gentle rethink prompt without immediately escalating to an explicit answer reveal.
- [ ] **AC-PRAC-05:** Requesting a hint flags the attempt as assisted (`assistance_level > 0`), ensuring it does not inflate unassisted mastery ($L_{\text{unassisted}}$).

### 2.4 LAM Recommendations & Safe Fallback
- [ ] **AC-REC-01:** Recommended next activities from LAM display with their pedagogical rationale (e.g. *"Spaced retrieval review due"*).
- [ ] **AC-REC-02:** If the backend or LAM times out (> 5 seconds), the circuit breaker safely displays the next curriculum topic without blocking the student or crashing.

### 2.5 Offline Resilience & Idempotent Sync
- [ ] **AC-OFF-01:** In airplane mode, practice attempts are committed to the local `sync_outbox` table with client-minted UUIDs.
- [ ] **AC-OFF-02:** Upon reconnecting, the background sync worker flushes pending events chronologically in batches of 20.
- [ ] **AC-OFF-03:** Re-submitting the same batch twice produces 0 duplicate ledger events in the backend (`ON CONFLICT (id) DO NOTHING`).

### 2.6 Performance on Budget Devices (Moto G / Redmi 2GB RAM)
- [ ] **AC-PERF-01:** Cold app launch to interactive home screen completes in $< 2.0\text{ seconds}$.
- [ ] **AC-PERF-02:** Practice question transition animations maintain $\ge 55\text{ FPS}$ with zero frame drops during card selections.
- [ ] **AC-PERF-03:** Active application memory does not exceed $110\text{ MB}$ during a 30-minute practice session.

---

## 3. Test Execution Matrix

| Test Suite | Command | Execution Environment | Mocked Services |
| :--- | :--- | :--- | :--- |
| **Unit Tests** | `flutter test test/unit/` | Local CLI / CI Runner | All network & storage mocked |
| **Widget Tests** | `flutter test test/widget/` | Local CLI / CI Runner | Mock `ApiClient` & `SecureStorage` |
| **Integration Tests** | `flutter test integration_test/` | Connected Android Device / Emulator | Live Staging Backend & Test Supabase DB |
| **Accessibility Audit** | `flutter test test/a11y/` | Local CLI (Semantics checks) | Screen reader automated assertions |
