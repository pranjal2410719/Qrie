# Qrie Student App — Open Questions & Architectural Decision Log

**Document Reference:** `docs/student-app/OPEN_QUESTIONS.md`  
**Status:** Active Tracking  
**Author:** Principal Product Architect & Security Lead  

---

## 1. Active Open Questions & Architectural Uncertainties

### Question 1: Parental Account Ownership vs Minor Self-Enrollment (DPDP Act)
- **Context:** Under India's Digital Personal Data Protection (DPDP) Act 2023, processing personal data of children under 18 requires verifiable parental consent, unless authorized under an institutional school contract.
- **Current State:** Migration `0005_tenancy.sql` created `organization` with `kind in ('solo', 'school')` specifically noting that whether the account holder is the child or parent remains an open product decision.
- **Options Under Consideration:**
  - *Option A (School-Direct):* The school acts as the Data Fiduciary. Students log in via school-provisioned roll codes with institutional consent.
  - *Option B (Parent-Managed):* Parents create the account via phone OTP and provision a child profile.
- **Recommended Action for MVP:** Support Option A (School-Direct) for institutional rollouts, and allow a frictionless "Solo Learner" mode with zero personal data collection (pseudonymous local profile) for independent students.

---

### Question 2: Math Equation Input on Budget Mobile Keyboards
- **Context:** High school mathematics (Classes 9–11) requires answering algebraic questions (e.g., $2x^2 - 5x + 3 = 0$). Standard Android soft keyboards lack mathematical symbols (fractions, exponents, radicals).
- **Options Under Consideration:**
  - *Option A (Custom Virtual Math Keypad):* Build a custom in-app math keypad supporting $\frac{a}{b}$, $x^2$, $\sqrt{x}$, $\pm$.
  - *Option B (Categorized Scaffolding / Multiple Choice with Numeric Keys):* Structure questions as numerical coefficient inputs or multiple-choice reasoning steps.
- **Recommended Action for MVP:** Use Option B for MVP (numeric keypad input for roots and coefficients; multiple choice for algebraic expressions). Implement Option A in V1.

---

### Question 3: Offline Content Pre-Caching Budget
- **Context:** Budget devices in rural or semi-urban regions frequently have limited available internal storage (< 2GB free space).
- **Current State:** NCERT lessons with embedded SVGs and diagrams average $1.2\text{ MB}$ per lesson. A full Class 10 Science subject (16 chapters, ~60 lessons) would require ~75MB storage.
- **Recommended Action:**
  - Pre-bundle only the active chapter (e.g. Chapter 1) in initial app data (~8MB).
  - Provide an explicit "Download Chapter for Offline Study" toggle with size indicators (e.g. *"Download Chapter 2 (12 MB)"*).
  - Cap total cache size to $150\text{ MB}$ with Least-Recently-Used (LRU) automatic eviction of completed lessons.

---

### Question 4: Push Notification Quiet Hours for Minors
- **Context:** Spaced retrieval practice requires reminding students when a memory consolidation review is due. However, notifications during school hours (8 AM – 3 PM) or late night (after 9 PM) disrupt classes and sleep.
- **Recommended Action:**
  - Hard-code strict notification quiet hours: Zero push notifications between 8:00 AM – 3:30 PM (school hours) and 9:00 PM – 7:00 AM (night).
  - Deliver retrieval practice reminders strictly during the student's designated evening study window (e.g. 5:30 PM – 7:30 PM).
