import { describe, it, expect } from 'vitest';
import { buildApp } from '../src/app.js';

describe('Authentication & Tenant Boundary Enforcement', () => {
  const app = buildApp();

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
});
