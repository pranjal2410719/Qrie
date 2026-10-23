# Qrie AI Platform

> **Adaptive, School-Ready Learning Platform for NCERT Classes 6–12**

Qrie AI pairs an intuitive multi-portal learning experience with an autonomous learning adaptation engine. It provides dedicated experiences for **Students** (Android-first Flutter application), **Teachers** (Next.js classroom mastery portal), and **School Administrators** (Next.js institutional management portal), supported by a high-throughput **Fastify Node.js Application Backend** and a decoupled **Learning Adaptation Model (LAM)** service.

---

## 1. System Architecture

```
                      +------------------------------------------+
                      |         Student Android Client           |
                      |          (Flutter / Dart App)            |
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

## 2. Workspace Organization

```text
qrie-platform/
├── backend/                  # Fastify + TypeScript Application Backend
│   ├── src/                  # Modules: health, auth, teacher, admin, lam-integration
│   ├── tests/                # Automated Vitest test suite (51 passing as of 2026-10-23)
│   └── package.json
│
├── web-app/                  # Next.js 14+ Web Application (App Router)
│   ├── app/(teacher)/        # Teacher Portal (Dashboard, class mastery, struggle alerts)
│   ├── app/(admin)/          # School Admin Portal (Staff roster, class sections, audit)
│   └── package.json
│
├── android-app/qrie/         # Flutter Mobile Application for Students
│   ├── lib/main.dart         # Flutter application entrypoint
│   └── pubspec.yaml
│
├── supabase/                 # Database Migrations & Edge Functions
│   ├── migrations/           # 13 SQL migrations (Tenancy, RLS, Ledger, Retention)
│   └── functions/lam-relay/  # Self-contained Deno Edge Function adapter to LAM
│
└── docs/                     # Architecture & Implementation Specifications
    ├── ARCHITECTURE.md       # ADR-001 System architecture & boundaries
    ├── AUTHORIZATION_MATRIX.md # Role-based permissions matrix
    ├── DATABASE_SCHEMA.md    # Multi-tenant PostgreSQL relational schema
    ├── API_CONTRACT.md       # Versioned REST API endpoints
    └── IMPLEMENTATION_ROADMAP.md # Phase execution milestones
```

---

## 3. Key Design Principles

1. **Strict Service Decoupling:**
   - The **LAM service** (in `../lam`) owns Bayesian Knowledge Tracing (BKT), 9-level assistance escalation, and spaced retrieval scheduling.
   - The Qrie backend talks to LAM strictly server-to-server. Mobile and web clients **never** talk directly to LAM or hold privileged LAM keys.
2. **Multi-Tenant Isolation:**
   - Every database record and API query is strictly scoped by `school_id`.
   - Backend middleware rejects cross-tenant access attempts (`403 Forbidden`).
3. **Role-Based Access Control:**
   - Distinct server-enforced roles: `student`, `teacher`, `school_admin`, and `super_admin`.
4. **Resilient Failure Handling:**
   - The backend LAM adapter implements automated circuit-breaking and returns deterministic pedagogical fallback recommendations if LAM is temporarily offline.

---

## 4. Getting Started Locally

### Prerequisites
- **Node.js:** v18+ (v22 recommended)
- **npm** or **pnpm**
- **Flutter SDK:** ^3.13.5 (for mobile app)

### 1. Backend Service (`backend/`)
```bash
cd backend
cp .env.example .env
npm install
npm run dev      # Server starts on http://localhost:4000
npm test         # Runs Vitest automated suite (10 tests)
npm run build    # Compiles TypeScript with zero errors
```

### 2. Teacher & Admin Web Portals (`web-app/`)
```bash
cd web-app
cp .env.example .env.local
npm install
npm run dev      # Portal accessible on http://localhost:3000
npm run build    # Creates optimized Next.js production build
```

- **Portal Gateway:** `http://localhost:3000/`
- **Teacher Dashboard:** `http://localhost:3000/teacher/dashboard`
- **Admin Dashboard:** `http://localhost:3000/admin/dashboard`

### 3. Student Mobile App (`android-app/qrie/`)
```bash
cd android-app/qrie
flutter pub get
flutter run      # Launches on connected Android device / emulator
```

---

## 5. Verification Status

| Component | Test / Build Command | Result |
| :--- | :--- | :---: |
| **Backend API** | `npm run build && npm test` | ✅ **51/51 Passed** (0 TypeScript errors) |
| **Web Portals** | `npm run build` | ✅ **Prerendered (6/6 routes)** (0 build errors) |
| **Supabase** | Migration sequential audit | ✅ **13/13 Validated** (0001 to 0013) |
| **LAM Decoupling** | Adapter circuit-breaker & fallback | ✅ **Verified** (Zero direct client access) |

---

## 6. Git Push Instructions for New Repository

To initialize this workspace and push to your new GitHub repository:

```bash
cd /home/dev/Desktop/projects/ai-tuitor/qrie-platform

# 1. Initialize local repository
git init -b main

# 2. Stage all verified files (respecting .gitignore)
git add .

# 3. Create initial commit
git commit -m "feat: initial commit for Qrie AI platform (backend, web-app, android-app, supabase, docs)"

# 4. Link your new GitHub remote
git remote add origin <YOUR_NEW_GITHUB_REPO_URL>

# 5. Push to main
git push -u origin main
```
