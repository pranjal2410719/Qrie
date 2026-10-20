# Qrie AI — Role & Tenant Authorization Matrix

## 1. System Roles

| Role | Scope | Description |
| :--- | :--- | :--- |
| **`student`** | Self + Enrolled Classes | Learner attending classes 6–12. Can access personal sessions, assignments, and submit answers. |
| **`teacher`** | Assigned Classes in School | Educator managing one or more class sections. Can view student progress, assign interventions. |
| **`school_admin`** | School Scope | Principal or school administrator. Can manage rosters, teachers, classes, and school settings. |
| **`super_admin`** | Global Platform Scope | Internal Qrie platform operator. Can manage schools, tenant provisioning, and global system health. |

---

## 2. Resource Permissions Matrix

| Resource | Action | Student | Teacher | School Admin | Super Admin |
| :--- | :--- | :---: | :---: | :---: | :---: |
| **School Configuration** | Read | ❌ | Allowed (own) | Allowed (own) | Allowed (all) |
| **School Configuration** | Write | ❌ | ❌ | Allowed (own) | Allowed (all) |
| **Teacher Profiles** | Read | ❌ | Allowed (own school) | Allowed (own school) | Allowed (all) |
| **Teacher Profiles** | Manage | ❌ | ❌ | Allowed (own school) | Allowed (all) |
| **Class Sections** | Read | Enrolled only | Assigned only | Own school | All |
| **Class Sections** | Manage | ❌ | ❌ | Own school | All |
| **Student Roster** | Read | Self only | Assigned classes | Own school | All |
| **Student Roster** | Manage | ❌ | ❌ | Own school | All |
| **Curriculum & Lessons** | Read | Enrolled subjects | Own school | Own school | All |
| **Curriculum & Lessons** | Manage | ❌ | ❌ | Own school | All |
| **Assessments** | Submit | Allowed (own) | ❌ | ❌ | ❌ |
| **Assessments** | Grade/Review | ❌ | Allowed (assigned) | Allowed (own school) | All |
| **Learning Progress** | View | Self only | Assigned classes | Own school aggregated | All |
| **Audit Logs** | Read | ❌ | ❌ | Allowed (own school) | All |

---

## 3. Enforcement Layers

1. **API Gateway / Middleware Layer:**
   - Extracts JWT Bearer token.
   - Verifies cryptographic signature and expiration.
   - Resolves `userId`, `schoolId`, and `roles`.
   - Rejects unauthenticated requests (`401 Unauthorized`).
   - Rejects unauthorized cross-tenant requests (`403 Forbidden`).
2. **Database RLS Layer:**
   - PostgreSQL queries execute with `SET LOCAL request.jwt.claim.school_id = ...`.
   - Prevents SQL injection or logic bugs in backend from accessing foreign tenant data.
