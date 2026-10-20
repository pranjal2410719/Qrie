import { FastifyInstance } from 'fastify';
import { z } from 'zod';
import { authenticate, requireRole } from '../../middleware/auth.js';

export async function adminRoutes(app: FastifyInstance) {
  // Requires school_admin or super_admin
  app.addHook('preHandler', authenticate);
  app.addHook('preHandler', requireRole(['school_admin', 'super_admin']));

  /**
   * School summary and analytics overview.
   */
  app.get('/school', async (request, reply) => {
    const schoolId = request.user!.schoolId;

    return reply.status(200).send({
      school: {
        id: schoolId,
        name: 'Delhi Public School, Sector 4',
        code: 'DEL-DPS-004',
        total_students: 480,
        total_teachers: 32,
        total_classes: 16,
        academic_year: '2026-2027',
        status: 'active',
      },
    });
  });

  /**
   * Provisions a new class section.
   */
  app.post('/classes', async (request, reply) => {
    const schema = z.object({
      grade: z.number().int().min(6).max(12),
      section: z.string().min(1).max(8),
      academic_year: z.string().default('2026-2027'),
    });

    const body = schema.parse(request.body);
    const newClass = {
      id: `cls_${body.grade}${body.section.toLowerCase()}_${Date.now()}`,
      school_id: request.user!.schoolId,
      grade: body.grade,
      section: body.section,
      academic_year: body.academic_year,
      created_at: new Date().toISOString(),
    };

    return reply.status(201).send({ class: newClass });
  });

  /**
   * Enrolls a new student.
   */
  app.post('/students', async (request, reply) => {
    const schema = z.object({
      full_name: z.string().min(2),
      email: z.string().email(),
      grade: z.number().int().min(6).max(12),
      class_id: z.string(),
      roll_number: z.string(),
    });

    const body = schema.parse(request.body);
    const student = {
      id: `usr_std_${Date.now()}`,
      school_id: request.user!.schoolId,
      full_name: body.full_name,
      email: body.email,
      grade: body.grade,
      class_id: body.class_id,
      roll_number: body.roll_number,
      lam_student_id: `lam_std_${Buffer.from(body.email).toString('hex').slice(0, 16)}`,
      created_at: new Date().toISOString(),
    };

    return reply.status(201).send({ student });
  });
}
