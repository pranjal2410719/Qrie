import { FastifyRequest, FastifyReply } from 'fastify';
import { UnauthorizedError, ForbiddenError } from '../shared/errors.js';

export interface AuthUser {
  id: string;
  email: string;
  role: 'student' | 'teacher' | 'school_admin' | 'super_admin';
  schoolId: string;
}

declare module '@fastify/jwt' {
  interface FastifyJWT {
    user: AuthUser;
  }
}

export async function authenticate(request: FastifyRequest, _reply: FastifyReply) {
  try {
    await request.jwtVerify();
    const user = request.user as AuthUser;
    if (!user || !user.id || !user.schoolId || !user.role) {
      throw new UnauthorizedError('Malformed token claims: missing id, schoolId, or role');
    }
  } catch (err: any) {
    throw new UnauthorizedError(err.message || 'Invalid or expired token');
  }
}

export function requireRole(allowedRoles: Array<'student' | 'teacher' | 'school_admin' | 'super_admin'>) {
  return async (request: FastifyRequest, _reply: FastifyReply) => {
    if (!request.user) {
      throw new UnauthorizedError('Authentication required');
    }
    if (!allowedRoles.includes(request.user.role)) {
      throw new ForbiddenError(`Role '${request.user.role}' is not authorized for this resource`);
    }
  };
}

export function enforceTenantIsolation(targetSchoolId: string) {
  return async (request: FastifyRequest, _reply: FastifyReply) => {
    if (!request.user) {
      throw new UnauthorizedError('Authentication required');
    }
    if (request.user.role !== 'super_admin' && request.user.schoolId !== targetSchoolId) {
      throw new ForbiddenError('Cross-tenant data access strictly prohibited');
    }
  };
}
