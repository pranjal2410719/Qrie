import { describe, it, expect, vi, beforeEach, beforeAll } from 'vitest';
import { buildApp } from '../src/app.js';
import { Database } from '../src/database/index.js';

describe('Admin and Teacher Routes (Database-backed LMS)', () => {
  const app = buildApp();
  let adminToken: string;
  let teacherToken: string;
  let otherSchoolAdminToken: string;
  let studentToken: string;

  beforeAll(async () => {
    await app.ready();
    adminToken = app.jwt.sign(
      { id: 'usr_admin_1', email: 'admin@dps.edu', role: 'school_admin', schoolId: 'sch_dps_delhi' },
      { expiresIn: '1h' }
    );
    teacherToken = app.jwt.sign(
      { id: 'usr_teacher_1', email: 'teacher@dps.edu', role: 'teacher', schoolId: 'sch_dps_delhi' },
      { expiresIn: '1h' }
    );
    otherSchoolAdminToken = app.jwt.sign(
      { id: 'usr_admin_other', email: 'admin@other.edu', role: 'school_admin', schoolId: 'sch_other_mumbai' },
      { expiresIn: '1h' }
    );
    studentToken = app.jwt.sign(
      { id: 'usr_std_1', email: 'student@dps.edu', role: 'student', schoolId: 'sch_dps_delhi' },
      { expiresIn: '1h' }
    );
  });

  beforeEach(() => {
    vi.restoreAllMocks();
  });

  // -------------------------------------------------------------------------
  // Authorization checks
  // -------------------------------------------------------------------------

  it('rejects unauthenticated requests to admin routes with 401', async () => {
    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/school',
    });
    expect(res.statusCode).toBe(401);
  });

  it('rejects student role accessing admin routes with 403', async () => {
    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/school',
      headers: { authorization: `Bearer ${studentToken}` },
    });
    expect(res.statusCode).toBe(403);
  });

  it('rejects student role accessing teacher routes with 403', async () => {
    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/teacher/classes',
      headers: { authorization: `Bearer ${studentToken}` },
    });
    expect(res.statusCode).toBe(403);
  });

  // -------------------------------------------------------------------------
  // Admin module
  // -------------------------------------------------------------------------

  it('GET /api/v1/admin/school returns school profile with real aggregate metrics', async () => {
    vi.spyOn(Database, 'query').mockImplementation(async (sql: string, params?: any[]) => {
      if (sql.includes('SELECT id, name, code, academic_year, status FROM public.school')) {
        return {
          rows: [{
            id: 'sch_dps_delhi',
            name: 'Delhi Public School, Sector 4',
            code: 'DEL-DPS-004',
            academic_year: '2026-2027',
            status: 'active',
          }],
        } as any;
      }
      if (sql.includes('SELECT count(*)::int FROM public.student_enrollment')) {
        return {
          rows: [{
            total_students: 48,
            total_teachers: 5,
            total_classes: 2,
          }],
        } as any;
      }
      return { rows: [] } as any;
    });

    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/school',
      headers: { authorization: `Bearer ${adminToken}` },
    });

    expect(res.statusCode).toBe(200);
    const body = res.json();
    expect(body.school.id).toBe('sch_dps_delhi');
    expect(body.school.name).toBe('Delhi Public School, Sector 4');
    expect(body.school.total_students).toBe(48);
    expect(body.school.total_teachers).toBe(5);
    expect(body.school.total_classes).toBe(2);
  });

  it('POST /api/v1/admin/classes inserts a new class linked to the school tenant', async () => {
    let capturedParams: any[] = [];
    vi.spyOn(Database, 'query').mockImplementation(async (sql: string, params?: any[]) => {
      if (sql.includes('INSERT INTO public.school_class')) {
        capturedParams = params || [];
        return {
          rows: [{
            id: params![0],
            school_id: params![1],
            grade: params![2],
            section: params![3],
            name: params![4],
            subject: params![5],
            academic_year: params![6],
            created_at: new Date().toISOString(),
          }],
        } as any;
      }
      return { rows: [] } as any;
    });

    const res = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/classes',
      headers: { authorization: `Bearer ${adminToken}` },
      payload: {
        grade: 8,
        section: 'B',
        subject: 'Mathematics',
        academic_year: '2026-2027',
      },
    });

    expect(res.statusCode).toBe(201);
    const body = res.json();
    expect(body.class.grade).toBe(8);
    expect(body.class.section).toBe('B');
    expect(body.class.school_id).toBe('sch_dps_delhi');
    expect(capturedParams[1]).toBe('sch_dps_delhi');
  });

  it('POST /api/v1/admin/students validates class tenant ownership before enrollment', async () => {
    // Mock class NOT found in tenant
    vi.spyOn(Database, 'query').mockImplementation(async (sql: string) => {
      if (sql.includes('SELECT id FROM public.school_class')) {
        return { rows: [] } as any;
      }
      return { rows: [] } as any;
    });

    const res = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/students',
      headers: { authorization: `Bearer ${adminToken}` },
      payload: {
        full_name: 'Aarav Patel',
        email: 'aarav.patel@example.com',
        grade: 8,
        class_id: 'cls_foreign_school',
        roll_number: '12',
      },
    });

    expect(res.statusCode).toBe(404);
    expect(res.json().error).toMatch(/Class not found/);
  });

  it('POST /api/v1/admin/students enrolls student when class belongs to school', async () => {
    vi.spyOn(Database, 'query').mockImplementation(async (sql: string, params?: any[]) => {
      if (sql.includes('SELECT id FROM public.school_class')) {
        return { rows: [{ id: 'cls_8a' }] } as any;
      }
      if (sql.includes('INSERT INTO public.student_enrollment')) {
        return {
          rows: [{
            id: params![0],
            school_id: params![1],
            class_id: params![2],
            full_name: params![3],
            email: params![4],
            grade: params![5],
            roll_number: params![6],
            lam_student_id: params![7],
            created_at: new Date().toISOString(),
          }],
        } as any;
      }
      return { rows: [] } as any;
    });

    const res = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/students',
      headers: { authorization: `Bearer ${adminToken}` },
      payload: {
        full_name: 'Aarav Patel',
        email: 'aarav.patel@example.com',
        grade: 8,
        class_id: 'cls_8a',
        roll_number: '12',
      },
    });

    expect(res.statusCode).toBe(201);
    const body = res.json();
    expect(body.student.full_name).toBe('Aarav Patel');
    expect(body.student.school_id).toBe('sch_dps_delhi');
    expect(body.student.lam_student_id).toMatch(/^lam_std_/);
  });

  // -------------------------------------------------------------------------
  // Teacher module
  // -------------------------------------------------------------------------

  it('GET /api/v1/teacher/classes returns assigned classes with struggle counters', async () => {
    vi.spyOn(Database, 'query').mockImplementation(async (sql: string) => {
      if (sql.includes('FROM public.school_class c')) {
        return {
          rows: [
            {
              id: 'cls_8a_math',
              school_id: 'sch_dps_delhi',
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

    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/teacher/classes',
      headers: { authorization: `Bearer ${teacherToken}` },
    });

    expect(res.statusCode).toBe(200);
    const body = res.json();
    expect(body.classes).toHaveLength(1);
    expect(body.classes[0].id).toBe('cls_8a_math');
    expect(body.classes[0].struggling_students_count).toBe(3);
  });

  it('GET /api/v1/teacher/classes/:classId/students enforces tenant boundary', async () => {
    vi.spyOn(Database, 'query').mockImplementation(async (sql: string) => {
      if (sql.includes('SELECT id FROM public.school_class WHERE id = $1 AND school_id = $2')) {
        // Class belongs to another school
        return { rows: [] } as any;
      }
      return { rows: [] } as any;
    });

    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/teacher/classes/cls_other_school/students',
      headers: { authorization: `Bearer ${teacherToken}` },
    });

    expect(res.statusCode).toBe(404);
  });

  it('GET /api/v1/teacher/classes/:classId/students returns students with active struggles', async () => {
    vi.spyOn(Database, 'query').mockImplementation(async (sql: string) => {
      if (sql.includes('SELECT id FROM public.school_class')) {
        return { rows: [{ id: 'cls_8a_math' }] } as any;
      }
      if (sql.includes('FROM public.student_enrollment')) {
        return {
          rows: [
            {
              id: 'usr_std_01',
              school_id: 'sch_dps_delhi',
              class_id: 'cls_8a_math',
              full_name: 'Diya Sharma',
              roll_number: '02',
              overall_mastery: 0.52,
              status: 'struggling',
              active_struggles: [
                {
                  concept_id: 'ncert.math.08.rational_numbers.division',
                  concept_name: 'Division of Rational Numbers',
                  consecutive_failures: 3,
                },
              ],
              last_active: '2026-10-26T00:00:00.000Z',
            },
          ],
        } as any;
      }
      return { rows: [] } as any;
    });

    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/teacher/classes/cls_8a_math/students',
      headers: { authorization: `Bearer ${teacherToken}` },
    });

    expect(res.statusCode).toBe(200);
    const body = res.json();
    expect(body.class_id).toBe('cls_8a_math');
    expect(body.students).toHaveLength(1);
    expect(body.students[0].status).toBe('struggling');
    expect(body.students[0].active_struggles).toHaveLength(1);
  });

  it('GET /api/v1/teacher/classes/:classId/mastery-summary aggregates distribution', async () => {
    vi.spyOn(Database, 'query').mockImplementation(async (sql: string) => {
      if (sql.includes('SELECT id, name, subject FROM public.school_class')) {
        return { rows: [{ id: 'cls_8a_math', name: 'Class 8-A', subject: 'Mathematics' }] } as any;
      }
      if (sql.includes('WHERE class_id = $1 AND school_id = $2')) {
        return {
          rows: [{ high: 22, medium: 8, low: 4 }],
        } as any;
      }
      return { rows: [] } as any;
    });

    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/teacher/classes/cls_8a_math/mastery-summary',
      headers: { authorization: `Bearer ${teacherToken}` },
    });

    expect(res.statusCode).toBe(200);
    const body = res.json();
    expect(body.topics[0].mastery_distribution).toEqual({ high: 22, medium: 8, low: 4 });
  });
});
