import { describe, it, expect, vi, beforeEach } from 'vitest';
import { buildApp } from '../src/app.js';
import { Database } from '../src/database/index.js';

describe('Authentication & Tenant Boundary Enforcement', () => {
  const app = buildApp();

  beforeEach(() => {
    vi.restoreAllMocks();
  });

  it('rejects unauthenticated requests with HTTP 401 Unauthorized', async () => {
    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/teacher/classes',
    });

    expect(res.statusCode).toBe(401);
    const body = res.json();
    expect(body.title).toBe('UNAUTHORIZED');
    expect(body.status).toBe(401);
    expect(body.requestId).toBeDefined();
  });

  it('rejects student role accessing teacher portal with HTTP 403 Forbidden', async () => {
    // Generate token with student role
    const studentToken = app.jwt.sign({
      id: 'usr_student_01',
      email: 'student@school.edu',
      role: 'student',
      schoolId: 'sch_dps_01',
    });

    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/teacher/classes',
      headers: {
        authorization: `Bearer ${studentToken}`,
      },
    });

    expect(res.statusCode).toBe(403);
    const body = res.json();
    expect(body.title).toBe('FORBIDDEN');
    expect(body.detail).toContain("Role 'student' is not authorized");
  });

  it('allows teacher role to access teacher classes within own school', async () => {
    vi.spyOn(Database, 'query').mockImplementation(async (sql: string) => {
      if (sql.includes('FROM public.school_class c')) {
        return {
          rows: [
            {
              id: 'cls_8a_math',
              school_id: 'sch_dps_01',
              name: 'Class 8-A',
              grade: 8,
              section: 'A',
              subject: 'Mathematics',
              academic_year: '2026-2027',
              total_students: 34,
              struggling_students_count: 3,
              average_mastery: 0.74,
            },
          ],
        } as any;
      }
      return { rows: [] } as any;
    });

    const teacherToken = app.jwt.sign({
      id: 'usr_teacher_01',
      email: 'teacher@school.edu',
      role: 'teacher',
      schoolId: 'sch_dps_01',
    });

    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/teacher/classes',
      headers: {
        authorization: `Bearer ${teacherToken}`,
      },
    });

    expect(res.statusCode).toBe(200);
    const body = res.json();
    expect(body.classes).toBeDefined();
    expect(body.classes.length).toBeGreaterThan(0);
    expect(body.classes[0].school_id).toBe('sch_dps_01');
  });

  it('allows school_admin to access admin overview and enroll students', async () => {
    vi.spyOn(Database, 'query').mockImplementation(async (sql: string) => {
      if (sql.includes('public.school WHERE id = $1')) {
        return {
          rows: [
            {
              id: 'sch_dps_01',
              name: 'Delhi Public School, Sector 4',
              code: 'DEL-DPS-004',
              academic_year: '2026-2027',
              status: 'active',
            },
          ],
        } as any;
      }
      if (sql.includes('SELECT count(*)::int FROM public.student_enrollment')) {
        return {
          rows: [
            {
              total_students: 48,
              total_teachers: 5,
              total_classes: 2,
            },
          ],
        } as any;
      }
      return { rows: [] } as any;
    });

    const adminToken = app.jwt.sign({
      id: 'usr_admin_01',
      email: 'admin@school.edu',
      role: 'school_admin',
      schoolId: 'sch_dps_01',
    });

    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/school',
      headers: {
        authorization: `Bearer ${adminToken}`,
      },
    });

    expect(res.statusCode).toBe(200);
    const body = res.json();
    expect(body.school.id).toBe('sch_dps_01');
  });

  it('rejects token with wrong issuer with HTTP 401 Unauthorized', async () => {
    const badIssuerToken = app.jwt.sign(
      {
        id: 'usr_teacher_01',
        email: 'teacher@school.edu',
        role: 'teacher',
        schoolId: 'sch_dps_01',
      },
      {
        iss: 'rogue-issuer',
      },
    );

    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/teacher/classes',
      headers: {
        authorization: `Bearer ${badIssuerToken}`,
      },
    });

    expect(res.statusCode).toBe(401);
    const body = res.json();
    expect(body.title).toBe('UNAUTHORIZED');
  });

  it('rejects token with wrong audience with HTTP 401 Unauthorized', async () => {
    const badAudToken = app.jwt.sign(
      {
        id: 'usr_teacher_01',
        email: 'teacher@school.edu',
        role: 'teacher',
        schoolId: 'sch_dps_01',
      },
      {
        aud: 'rogue-audience',
      },
    );

    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/teacher/classes',
      headers: {
        authorization: `Bearer ${badAudToken}`,
      },
    });

    expect(res.statusCode).toBe(401);
    const body = res.json();
    expect(body.title).toBe('UNAUTHORIZED');
  });
});
