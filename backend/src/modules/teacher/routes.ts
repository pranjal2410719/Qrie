import { FastifyInstance } from 'fastify';
import { authenticate, requireRole } from '../../middleware/auth.js';

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

    // Structured return adhering to schema
    const classes = [
      {
        id: 'cls_8a_math',
        school_id: schoolId,
        name: 'Class 8-A',
        grade: 8,
        section: 'A',
        subject: 'Mathematics',
        total_students: 34,
        struggling_students_count: 3,
        average_mastery: 0.74,
      },
      {
        id: 'cls_9b_math',
        school_id: schoolId,
        name: 'Class 9-B',
        grade: 9,
        section: 'B',
        subject: 'Mathematics',
        total_students: 31,
        struggling_students_count: 5,
        average_mastery: 0.68,
      },
    ];

    return reply.status(200).send({ classes });
  });

  /**
   * Retrieves students enrolled in a class with learning struggle indicators.
   */
  app.get('/classes/:classId/students', async (request, reply) => {
    const { classId } = request.params as { classId: string };
    const schoolId = request.user!.schoolId;

    const students = [
      {
        id: 'std_01',
        school_id: schoolId,
        class_id: classId,
        full_name: 'Aarav Patel',
        roll_number: '01',
        overall_mastery: 0.85,
        status: 'on_track',
        active_struggles: [],
        last_active: new Date().toISOString(),
      },
      {
        id: 'std_02',
        school_id: schoolId,
        class_id: classId,
        full_name: 'Diya Sharma',
        roll_number: '02',
        overall_mastery: 0.52,
        status: 'struggling',
        active_struggles: [
          {
            concept_id: 'ncert.math.08.rational_numbers.division',
            concept_name: 'Division of Rational Numbers',
            consecutive_failures: 3,
            misconception_suspected: 'invert_and_multiply_neglect',
          },
        ],
        last_active: new Date().toISOString(),
      },
    ];

    return reply.status(200).send({ class_id: classId, students });
  });

  /**
   * Aggregated topic mastery and struggles summary.
   */
  app.get('/classes/:classId/mastery-summary', async (request, reply) => {
    const { classId } = request.params as { classId: string };

    return reply.status(200).send({
      class_id: classId,
      topics: [
        {
          chapter: 'Rational Numbers',
          mastery_distribution: { high: 22, medium: 8, low: 4 },
          common_misconceptions: ['Reciprocal sign confusion'],
        },
        {
          chapter: 'Linear Equations in One Variable',
          mastery_distribution: { high: 18, medium: 10, low: 6 },
          common_misconceptions: ['Transposition sign error'],
        },
      ],
    });
  });
}
