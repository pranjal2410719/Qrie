# Qrie AI Architecture Specification & Decision Record (ADR-001)

## 1. System Context & High-Level Architecture

Qrie AI is an adaptive, school-ready learning platform designed for Indian school education (NCERT Classes 6–12). The system decouples application operations (schools, classes, lesson delivery, portal experiences) from adaptive learning intelligence (Bayesian Knowledge Tracing, spaced retrieval, misconception tracking).

```
                      +------------------------------------------+
                      |         Student Android Client           |
                      |   (Flutter - Mobile low-bandwidth)       |
                      +---------------------+--------------------+
                                            |
                                            | HTTPS / WSS
                                            v
+------------------------+      +---------------------------+      +------------------------+
|   Teacher Web Portal   | ---> |     Qrie App Backend      | <--- |    Admin Web Portal    |
|   (Next.js App Router) |      |   (Node.js / Fastify)     |      |  (Next.js App Router)  |
+------------------------+      +-------------+-------------+      +------------------------+
                                              |
                       +----------------------+-----------------------+
                       |                                              |
                       v                                              v
           +-----------------------+                      +-----------------------+
           |  Supabase / Postgres  |                      |    LAM Relay Client   |
           |  (App DB, Tenancy,    |                      |   (Server-to-Server)  |
           |   RLS, Events, Auth)  |                      +-----------+-----------+
           +-----------------------+                                  |
                                                                      | Internal VPC / JWT
                                                                      v
                                                          +-----------------------+
                                                          |  LAM (FastAPI Engine) |
                                                          |   (BKT, Eligibility,  |
                                                          |    Recommendations)   |
                                                          +-----------------------+
```

---

## 2. Responsibility Boundaries

### A. Qrie Application Backend (`backend/`)
* **Identity & Tenancy:** Multi-school tenancy isolation (`school_id`), school profiles, memberships, role assignments.
* **Academic Roster:** Classes, sections, student enrollments, teacher assignments.
* **Curriculum & Delivery:** NCERT syllabus hierarchy (Subject → Chapter → Topic → Concept), lesson sequence delivery.
* **Assessment & Evidence:** Question verification, symbolic math checks, answer-key grading, trustworthy evidence creation.
* **Orchestration:** Initiates learning sessions, records immutable interaction events, and consults LAM for next actions.
* **Reporting:** Teacher-facing class analytics, struggle indicators, and administrative operational views.

### B. LAM Service (`../lam/`)
* **Autonomous Learning Intelligence:** Bayesian Knowledge Tracing (BKT: $L_0, T, G, S$), 9-level assistance escalation, spaced retrieval decaying half-life, misconception diagnosis state machines.
* **Persistence:** Independent PostgreSQL event ledger, learner state transitions, hypothesis audit entries.
* **Zero Direct Access:** Android mobile clients and Web portals **never** call LAM directly or hold LAM secrets.

### C. Web Application (`web-app/`)
* **Teacher Portal (`/(teacher)`):** Live class monitoring, mastery heatmaps, struggle alerts, intervention tools.
* **Admin Portal (`/(admin)`):** School management, student/teacher enrollment, curriculum assignments, audit logs.

### D. Student Application (`android-app/`)
* Android-first Flutter client optimized for low-spec devices and low-bandwidth connections.

---

## 3. Technology Stack Decisions

| Layer | Selected Technology | Rationale |
| :--- | :--- | :--- |
| **Backend Framework** | **Fastify (Node.js + TypeScript)** | 2x-3x higher throughput than Express, built-in schema compilation, native request ID tracking, structured logging. |
| **Web Frontend** | **Next.js 14+ (App Router)** | Server Components for low bundle sizes, unified layout system for `/(teacher)` and `/(admin)`, type safety. |
| **Database & Auth** | **PostgreSQL 16 + Supabase** | High-performance relational persistence, built-in Row-Level Security (RLS) for multi-tenancy, transactional safety. |
| **Mobile App** | **Flutter (Dart)** | Native 60fps performance on low-cost Android hardware, single codebase, robust offline storage. |
| **Learner Engine** | **FastAPI + asyncpg (Python)** | High-precision numerical computing, BKT algorithms, validated and isolated in `../lam`. |

---

## 4. Multi-Tenant Isolation Model

1. **Row-Level Security (RLS):** Every application table contains `school_id UUID NOT NULL`. RLS policies strictly filter rows where `school_id = auth.jwt() ->> 'school_id'`.
2. **Backend Defense-in-Depth:** Every Fastify service layer validates `tenantId` from the verified session context before querying the database, never accepting client-supplied tenant overrides.
