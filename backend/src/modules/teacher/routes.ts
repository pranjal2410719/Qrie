import { FastifyInstance } from 'fastify';
import { authenticate, requireRole } from '../../middleware/auth.js';
import { Database } from '../../database/index.js';

export async function teacherRoutes(app: FastifyInstance) {
  // All routes require teacher or school_admin role
  app.addHook('preHandler', authenticate);
  app.addHook('preHandler', requireRole(['teacher', 'school_admin']));

  /**
   * Retrieves classes assigned to the authenticated teacher.
   */
  app.get('/classes', async (request, reply) => {
    const teacherId = request.user!.id;
    const schoolId = request.user!.schoolId;

    const res = await Database.query(
      `SELECT c.id, c.school_id, c.name, c.grade, c.section, c.subject, c.academic_year,
              COALESCE(count(s.id), 0)::int as total_students,
              COALESCE(count(s.id) FILTER (WHERE s.status = 'struggling'), 0)::int as struggling_students_count,
              COALESCE(round(avg(s.overall_mastery)::numeric, 2)::float, 0.70) as average_mastery
       FROM public.school_class c
       LEFT JOIN public.student_enrollment s ON s.class_id = c.id
       WHERE c.school_id = $1
         AND (
           EXISTS (SELECT 1 FROM public.teacher_assignment ta WHERE ta.class_id = c.id AND ta.teacher_id = $2)
           OR NOT EXISTS (SELECT 1 FROM public.teacher_assignment ta WHERE ta.teacher_id = $2)
         )
       GROUP BY c.id
       ORDER BY c.grade, c.section`,
      [schoolId, teacherId]
    );

    return reply.status(200).send({ classes: res.rows });
  });

  /**
   * Retrieves students enrolled in a class with learning struggle indicators.
   */
  app.get('/classes/:classId/students', async (request, reply) => {
    const { classId } = request.params as { classId: string };
    const schoolId = request.user!.schoolId;

    // Verify tenant ownership of the class
    const classRes = await Database.query(
      `SELECT id FROM public.school_class WHERE id = $1 AND school_id = $2`,
      [classId, schoolId]
    );

    if (classRes.rows.length === 0) {
      return reply.status(404).send({
        error: 'Class not found or does not belong to this institution',
      });
    }

    const studentsRes = await Database.query(
      `SELECT id, school_id, class_id, full_name, roll_number,
              overall_mastery::float, status, active_struggles, last_active
       FROM public.student_enrollment
       WHERE class_id = $1 AND school_id = $2
       ORDER BY roll_number, full_name`,
      [classId, schoolId]
    );

    return reply.status(200).send({
      class_id: classId,
      students: studentsRes.rows,
    });
  });

  /**
   * Aggregated topic mastery and struggles summary.
   */
  app.get('/classes/:classId/mastery-summary', async (request, reply) => {
    const { classId } = request.params as { classId: string };
    const schoolId = request.user!.schoolId;

    // Verify tenant ownership of the class
    const classRes = await Database.query(
      `SELECT id, name, subject FROM public.school_class WHERE id = $1 AND school_id = $2`,
      [classId, schoolId]
    );

    if (classRes.rows.length === 0) {
      return reply.status(404).send({
        error: 'Class not found or does not belong to this institution',
      });
    }

    const distributionRes = await Database.query(
      `SELECT
         COALESCE(count(*) FILTER (WHERE overall_mastery >= 0.8), 0)::int as high,
         COALESCE(count(*) FILTER (WHERE overall_mastery >= 0.6 AND overall_mastery < 0.8), 0)::int as medium,
         COALESCE(count(*) FILTER (WHERE overall_mastery < 0.6), 0)::int as low
       FROM public.student_enrollment
       WHERE class_id = $1 AND school_id = $2`,
      [classId, schoolId]
    );

    const dist = distributionRes.rows[0] || { high: 0, medium: 0, low: 0 };

    return reply.status(200).send({
      class_id: classId,
      topics: [
        {
          chapter: 'Rational Numbers',
          mastery_distribution: dist,
          common_misconceptions: ['Reciprocal sign confusion', 'Invert and multiply neglect'],
        },
      ],
    });
  });
}
