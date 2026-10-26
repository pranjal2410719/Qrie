import { describe, it, expect, beforeAll, vi, beforeEach } from 'vitest';
import { buildApp } from '../src/app.js';
import { Database } from '../src/database/index.js';
import * as eventStore from '../src/modules/student/event-store.js';

describe('Phase 9 — Adversarial Security, Tenancy & Anti-Tamper Verification', () => {
  const app = buildApp();
  let validStudentToken: string;
  let validTeacherToken: string;
  let expiredToken: string;

  beforeAll(async () => {
    await app.ready();
    validStudentToken = app.jwt.sign(
      { id: 'std_honest', email: 'honest@dps.edu', role: 'student', schoolId: 'sch_dps' },
      { expiresIn: '1h' }
    );
    validTeacherToken = app.jwt.sign(
      { id: 'usr_teacher', email: 'teacher@dps.edu', role: 'teacher', schoolId: 'sch_dps' },
      { expiresIn: '1h' }
    );
    // Explicit past epoch for expired token
    const pastExp = Math.floor(Date.now() / 1000) - 120;
    expiredToken = app.jwt.sign(
      {
        id: 'std_expired',
        email: 'expired@dps.edu',
        role: 'student',
        schoolId: 'sch_dps',
        exp: pastExp,
      }
    );
  });

  beforeEach(() => {
    vi.restoreAllMocks();
  });

  // -------------------------------------------------------------------------
  // 1. Signature & Token Tampering
  // -------------------------------------------------------------------------

  it('rejects expired JWT token with HTTP 401', async () => {
    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/learning/recommendations/next?concept_id=math.rational',
      headers: { authorization: `Bearer ${expiredToken}` },
    });

    expect(res.statusCode).toBe(401);
    expect(res.json().title).toBe('UNAUTHORIZED');
  });

  it('rejects tampered JWT signature with HTTP 401', async () => {
    const parts = validStudentToken.split('.');
    // Flip a character in signature
    const tamperedSig = parts[2].slice(0, -2) + (parts[2].endsWith('a') ? 'b' : 'a') + 'x';
    const tamperedToken = `${parts[0]}.${parts[1]}.${tamperedSig}`;

    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/learning/recommendations/next?concept_id=math.rational',
      headers: { authorization: `Bearer ${tamperedToken}` },
    });

    expect(res.statusCode).toBe(401);
    expect(res.json().title).toBe('UNAUTHORIZED');
  });

  // -------------------------------------------------------------------------
  // 2. Body Property Pollution & Spoofing Defense
  // -------------------------------------------------------------------------

  it('ignores client-supplied is_correct and xp_awarded in answer grading', async () => {
    // Student answers WRONG (numeric_input = 999 instead of 25)
    // but attempts to inject is_correct: true and xp_awarded: 500
    const res = await app.inject({
      method: 'POST',
      url: '/api/v1/learning/sessions/sess_tamper/answers',
      headers: { authorization: `Bearer ${validStudentToken}` },
      payload: {
        question_id: 'q4',
        numeric_input: 999,
        is_correct: true,
        xp_awarded: 500,
        assistance_rung: 0,
      },
    });

    expect(res.statusCode).toBe(200);
    const body = res.json();
    // Must be graded FALSE regardless of injected payload
    expect(body.is_correct).toBe(false);
    expect(body.xp_awarded).toBe(0);
  });

  it('ignores client-supplied school_id in answer grading and locks to JWT tenant', async () => {
    const insertSpy = vi.spyOn(eventStore, 'insertEvents').mockResolvedValue({
      inserted: 1,
      duplicateCount: 0,
      insertedIds: ['evt_ans_test'],
    });

    const res = await app.inject({
      method: 'POST',
      url: '/api/v1/learning/sessions/sess_tamper/answers',
      headers: { authorization: `Bearer ${validStudentToken}` },
      payload: {
        question_id: 'q4',
        numeric_input: 25,
        school_id: 'sch_rogue_institution',
        student_id: 'std_other',
      },
    });

    expect(res.statusCode).toBe(200);
    const body = res.json();
    expect(body.is_correct).toBe(true);
    expect(body.session_id).toBe('sess_tamper');
    expect(body.event_id).toBeDefined();

    // Verify tenant parameters passed to insertEvents came strictly from JWT
    expect(insertSpy).toHaveBeenCalledWith(
      'sch_dps',
      'std_honest',
      expect.any(Array)
    );
  });

  // -------------------------------------------------------------------------
  // 3. SQL Injection Resistance
  // -------------------------------------------------------------------------

  it('safely handles SQL injection payloads in teacher class lookup without leaking data', async () => {
    let capturedSql = '';
    let capturedParams: any[] = [];

    vi.spyOn(Database, 'query').mockImplementation(async (sql: string, params?: any[]) => {
      capturedSql = sql;
      capturedParams = params || [];
      return { rows: [] } as any;
    });

    const maliciousClassId = "cls_8a' OR '1'='1";
    const res = await app.inject({
      method: 'GET',
      url: `/api/v1/teacher/classes/${encodeURIComponent(maliciousClassId)}/students`,
      headers: { authorization: `Bearer ${validTeacherToken}` },
    });

    expect(res.statusCode).toBe(404);
    // Verified parameterization: the injection string was passed as parameter $1, NOT inlined into SQL
    expect(capturedParams).toContain(maliciousClassId);
    expect(capturedSql).not.toContain("OR '1'='1");
  });

  // -------------------------------------------------------------------------
  // 4. Cross-Tenant Object Boundary Enforcements
  // -------------------------------------------------------------------------

  it('blocks teacher from accessing class roster belonging to a foreign school tenant', async () => {
    vi.spyOn(Database, 'query').mockImplementation(async (sql: string, params?: any[]) => {
      // If querying by school_id, return empty if foreign
      if (sql.includes('SELECT id FROM public.school_class WHERE id = $1 AND school_id = $2')) {
        const [, requestingSchool] = params || [];
        if (requestingSchool !== 'sch_foreign') {
          return { rows: [] } as any; // Foreign class not visible
        }
      }
      return { rows: [] } as any;
    });

    const res = await app.inject({
      method: 'GET',
      url: '/api/v1/teacher/classes/cls_foreign_only/students',
      headers: { authorization: `Bearer ${validTeacherToken}` },
    });

    expect(res.statusCode).toBe(404);
    expect(res.json().error).toMatch(/does not belong to this institution/);
  });
});
