import { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { authenticate, requireRole } from '../../middleware/auth.js';
import { Database } from '../../database/index.js';

export async function adminRoutes(app: FastifyInstance) {
  // Requires school_admin or super_admin
  app.addHook('preHandler', authenticate);
  app.addHook('preHandler', requireRole(['school_admin', 'super_admin']));

  /**
   * School summary and analytics overview.
   */
  app.get('/school', async (request, reply) => {
    const schoolId = request.user!.schoolId;

    // Fetch or initialize school metadata
    const schoolRes = await Database.query(
      `SELECT id, name, code, academic_year, status FROM public.school WHERE id = $1`,
      [schoolId]
    );

    let schoolRecord = schoolRes.rows[0];
    if (!schoolRecord) {
      schoolRecord = {
        id: schoolId,
        name: 'Delhi Public School, Sector 4',
        code: `DEL-DPS-${schoolId.slice(0, 4).toUpperCase()}`,
        academic_year: '2026-2027',
        status: 'active',
      };
      await Database.query(
        `INSERT INTO public.school (id, name, code, academic_year, status)
         VALUES ($1, $2, $3, $4, $5)
         ON CONFLICT (id) DO NOTHING`,
        [schoolRecord.id, schoolRecord.name, schoolRecord.code, schoolRecord.academic_year, schoolRecord.status]
      );
    }

    // Query aggregated operational metrics with tenant isolation
    const countsRes = await Database.query(
      `SELECT
         (SELECT count(*)::int FROM public.student_enrollment WHERE school_id = $1) as total_students,
         (SELECT count(DISTINCT teacher_id)::int FROM public.teacher_assignment WHERE school_id = $1) as total_teachers,
         (SELECT count(*)::int FROM public.school_class WHERE school_id = $1) as total_classes`,
      [schoolId]
    );

    const counts = countsRes.rows[0] || { total_students: 0, total_teachers: 0, total_classes: 0 };

    return reply.status(200).send({
      school: {
        id: schoolRecord.id,
        name: schoolRecord.name,
        code: schoolRecord.code,
        total_students: counts.total_students,
        total_teachers: counts.total_teachers,
        total_classes: counts.total_classes,
        academic_year: schoolRecord.academic_year,
        status: schoolRecord.status,
      },
    });
  });

  /**
   * Provisions a new class section.
   */
  app.post('/classes', async (request, reply) => {
    const schema = z.object({
      grade: z.number().int().min(1).max(12),
      section: z.string().min(1).max(8),
      subject: z.string().default('Mathematics'),
      academic_year: z.string().default('2026-2027'),
    });

    const body = schema.parse(request.body);
    const schoolId = request.user!.schoolId;
    const classId = `cls_${body.grade}${body.section.toLowerCase()}_${Date.now()}`;
    const className = `Class ${body.grade}-${body.section.toUpperCase()}`;

    const res = await Database.query(
      `INSERT INTO public.school_class (id, school_id, grade, section, name, subject, academic_year)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING id, school_id, grade, section, name, subject, academic_year, created_at`,
      [classId, schoolId, body.grade, body.section.toUpperCase(), className, body.subject, body.academic_year]
    );

    return reply.status(201).send({ class: res.rows[0] });
  });

  /**
   * Enrolls a new student.
   */
  app.post('/students', async (request, reply) => {
    const schema = z.object({
      full_name: z.string().min(2),
      email: z.string().email(),
      grade: z.number().int().min(1).max(12),
      class_id: z.string(),
      roll_number: z.string(),
    });

    const body = schema.parse(request.body);
    const schoolId = request.user!.schoolId;

    // Verify class exists and belongs to the authenticated school tenant
    const classRes = await Database.query(
      `SELECT id FROM public.school_class WHERE id = $1 AND school_id = $2`,
      [body.class_id, schoolId]
    );

    if (classRes.rows.length === 0) {
      return reply.status(404).send({
        error: 'Class not found or does not belong to this institution',
      });
    }

    const studentId = `usr_std_${Date.now()}`;
    const lamStudentId = `lam_std_${Buffer.from(body.email).toString('hex').slice(0, 16)}`;

    const res = await Database.query(
      `INSERT INTO public.student_enrollment (id, school_id, class_id, full_name, email, grade, roll_number, lam_student_id)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
       RETURNING id, school_id, class_id, full_name, email, grade, roll_number, lam_student_id, created_at`,
      [studentId, schoolId, body.class_id, body.full_name, body.email, body.grade, body.roll_number, lamStudentId]
    );

    return reply.status(201).send({ student: res.rows[0] });
  });

  /**
   * Assigns a teacher to a class section.
   */
  app.post('/teachers/assign', async (request, reply) => {
    const schema = z.object({
      teacher_id: z.string().min(1),
      class_id: z.string().min(1),
    });

    const body = schema.parse(request.body);
    const schoolId = request.user!.schoolId;

    const classRes = await Database.query(
      `SELECT id FROM public.school_class WHERE id = $1 AND school_id = $2`,
      [body.class_id, schoolId]
    );

    if (classRes.rows.length === 0) {
      return reply.status(404).send({
        error: 'Class not found or does not belong to this institution',
      });
    }

    const res = await Database.query(
      `INSERT INTO public.teacher_assignment (school_id, teacher_id, class_id)
       VALUES ($1, $2, $3)
       ON CONFLICT (teacher_id, class_id) DO UPDATE SET created_at = now()
       RETURNING id, school_id, teacher_id, class_id, created_at`,
      [schoolId, body.teacher_id, body.class_id]
    );

    return reply.status(201).send({ assignment: res.rows[0] });
  });
}
