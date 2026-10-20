# Qrie AI — Multi-Application Workspace Implementation Roadmap

## Overview

This roadmap governs the construction, verification, and deployment of the independent **Qrie AI** platform across its three applications (`backend/`, `web-app/`, `android-app/qrie/`).

---

## Phase Execution Checklist

- [x] **Phase A — Workspace Discovery & Baseline Inventory**
  - Audited legacy monorepo and extracted independent components into `qrie-platform/`.
  - Audited and verified isolated LAM service at `../lam`.
  - Cleaned up dependencies and separated project boundaries.

- [x] **Phase B — Architecture Decision Records & Structure Definition**
  - Created [`docs/ARCHITECTURE.md`](file:///home/dev/Desktop/projects/ai-tuitor/qrie-platform/docs/ARCHITECTURE.md) (ADR-001).
  - Defined 3-application target structure: `backend/`, `web-app/`, `android-app/`.
  - Configured comprehensive root and modular `.gitignore` files.

- [x] **Phase C — Database Schema, Roles & API Contracts**
  - Created [`docs/AUTHORIZATION_MATRIX.md`](file:///home/dev/Desktop/projects/ai-tuitor/qrie-platform/docs/AUTHORIZATION_MATRIX.md).
  - Created [`docs/DATABASE_SCHEMA.md`](file:///home/dev/Desktop/projects/ai-tuitor/qrie-platform/docs/DATABASE_SCHEMA.md).
  - Created [`docs/API_CONTRACT.md`](file:///home/dev/Desktop/projects/ai-tuitor/qrie-platform/docs/API_CONTRACT.md).
  - Formatted and organized 13 Supabase migrations in [`supabase/migrations/`](file:///home/dev/Desktop/projects/ai-tuitor/qrie-platform/supabase/migrations).

- [x] **Phase D — Minimum Viable Qrie Backend (`backend/`)**
  - Built Fastify + TypeScript backend project.
  - Implemented typed Zod config, health probes (`/health/live`, `/health/ready`).
  - Implemented JWT authentication & multi-tenant isolation middleware.
  - Implemented Teacher and School Admin API endpoints.
  - Implemented trusted server-to-server LAM adapter with safe fallback on outage.
  - Automated tests passing: **10/10 Vitest tests clean**.

- [x] **Phase E — Web Application Foundation (`web-app/`)**
  - Built Next.js 14 App Router project with Tailwind CSS.
  - Implemented Teacher Portal layout and dashboard with class mastery & struggle alerts.
  - Implemented School Admin Portal layout and dashboard with staff roster & compliance indicators.
  - Prerendered static production build: **`next build` passed with 0 errors**.

- [x] **Phase F — Android Student Mobile Application (`android-app/qrie/`)**
  - Flutter / Dart project initialized in `android-app/qrie/`.
  - Native Android configuration and application scaffolding ready for feature development.

- [ ] **Phase G — End-to-End Learning Lifecycle Integration**
  - Connect live student sessions in mobile app to backend verification pipeline.
  - Execute server-side event logging to Supabase and forward to live LAM staging.
  - Verify adaptive recommendation loop end-to-end.

- [ ] **Phase H — Staging & Production Deployment**
  - Push codebase to new remote GitHub repository.
  - Configure CI/CD pipelines (GitHub Actions) for backend and web-app.
  - Deploy backend to managed container runtime, web-app to Vercel/Node, and mobile app to Play Store testing track.
