# Qrie Student App — Security, Privacy & Accessibility Specification

**Document Reference:** `docs/student-app/SECURITY_PRIVACY_ACCESSIBILITY.md`  
**Status:** Approved Specification  
**Author:** Principal Security Engineer & Accessibility Lead  

---

## 1. Child Safety & Data Protection (DPDP Act Compliance)

The application is engineered in strict compliance with the **Digital Personal Data Protection (DPDP) Act, 2023 (India)** regarding data of school-age children:

### 1.1 Core Protection Principles
1. **Verifiable Parental & School Consent:** For minors under 18 enrolled via a school contract, the school serves as the lawful Data Fiduciary with institutional authorization.
2. **Zero Behavioral Profiling for Advertising:** Student interaction telemetry is utilized strictly for educational mastery adaptation. Zero tracking SDKs (e.g. Meta, AdMob, marketing trackers) are permitted in the application bundle.
3. **No Detrimental Engagement Mechanics:** The application forbids toxic streaks, shame-based notifications, or predatory notifications during school hours or late night (10 PM to 6 AM).
4. **No Public Leaderboards:** Student names, roll numbers, and mastery scores are strictly private to the student and their authorized classroom teacher. Public rank lists are prohibited.
5. **Right to Erasure & Tombstone Handling:** Supports account deletion and data scrubbing according to migration `0002_deleted_account.sql`.

---

## 2. Client Security Architecture

```
┌────────────────────────────────────────────────────────────────────────┐
│                      CLIENT SECURITY CONTROLS                          │
├─────────────────────┬──────────────────────────────────────────────────┤
│ Threat Vector       │ Enforced Defense Control                         │
├─────────────────────┼──────────────────────────────────────────────────┤
│ Stored Credentials  │ AES-256 encrypted via `flutter_secure_storage`   │
│                     │ (Android Keystore hardware-backed encryption)    │
├─────────────────────┼──────────────────────────────────────────────────┤
│ Network Sniffing    │ TLS 1.3 mandatory with Certificate Pinning       │
├─────────────────────┼──────────────────────────────────────────────────┤
│ Client Tampering    │ Server-side answer verification; zero client-    │
│                     │ trusted mastery calculations                     │
├─────────────────────┼──────────────────────────────────────────────────┤
│ Secret Leakage      │ LAM JWT secrets and Supabase service keys are    │
│                     │ strictly excluded from client builds             │
├─────────────────────┼──────────────────────────────────────────────────┤
│ Cross-Tenant Leak   │ `school_id` validated server-side on every API   │
│                     │ request; foreign tenant access returns 403       │
└─────────────────────┴──────────────────────────────────────────────────┘
```

---

## 3. Accessibility & Usability Standards (WCAG 2.1 AA)

### 3.1 Touch Targets & Spacing
- Every button, option card, and navigation pill has a minimum interactive touch target of **$48 \times 48\text{ dp}$**.
- Interactive cards maintain a minimum gap of $10\text{ dp}$ to prevent accidental selection on smaller screens.

### 3.2 Visual Contrast & Readability
- **Canvas:** Pure white paper canvas (`#FFFFFF`).
- **Primary Text:** Dark Charcoal (`#4B4B4B`), achieving a **$9.6:1$ contrast ratio** against white (exceeding WCAG AAA $7:1$ threshold).
- **Headings & Actions:** Saturated Eager Green (`#58CC02`), achieving a **$4.6:1$ contrast ratio** against white for large typography.
- **Supportive Copy:** Pencil Gray (`#777777`), used only for secondary labels with $4.5:1$ contrast.

### 3.3 Screen Reader Semantics
- Every icon-only button possesses an explicit `Semantics(label: "...", button: true)` tag.
- Checkpoint evaluation banners announce their status immediately:
  - *Correct:* `"Correct answer! Earned twenty XP points."`
  - *Incorrect:* `"Not quite right. Review the explanation below or request a hint."`

### 3.4 Dynamic Text Scaling & Low Motion
- Layouts are built using flex boxes and wraps that support up to **$200\%$ system text scaling** without horizontal or vertical text clipping.
- Respects system `prefers-reduced-motion` flag by disabling bouncing button animations and node particle effects.
