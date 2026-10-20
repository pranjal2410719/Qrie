import Fastify, { FastifyInstance, FastifyServerOptions } from 'fastify';
import cors from '@fastify/cors';
import jwt from '@fastify/jwt';
import sensible from '@fastify/sensible';
import crypto from 'crypto';

import { config } from './config/index.js';
import { AppError } from './shared/errors.js';
import { healthRoutes } from './modules/health/routes.js';
import { teacherRoutes } from './modules/teacher/routes.js';
import { adminRoutes } from './modules/admin/routes.js';

export function buildApp(opts: FastifyServerOptions = {}): FastifyInstance {
  const app = Fastify({
    genReqId: (req) => {
      const existing = req.headers['x-request-id'];
      if (typeof existing === 'string') return existing;
      return `req_${crypto.randomUUID().replace(/-/g, '').slice(0, 16)}`;
    },
    requestIdHeader: 'x-request-id',
    ...opts,
  });

  // Plugins
  app.register(cors, { origin: true });
  app.register(sensible);
  app.register(jwt, {
    secret: config.JWT_SECRET,
  });

  // Attach correlation ID to all outgoing responses
  app.addHook('onSend', async (request, reply) => {
    reply.header('x-request-id', request.id);
  });

  // Global RFC 7807 Exception Handler
  app.setErrorHandler((error: any, request, reply) => {
    const requestId = request.id;
    if (error instanceof AppError) {
      return reply.status(error.statusCode).send({
        type: 'about:blank',
        title: error.code,
        status: error.statusCode,
        detail: error.message,
        instance: request.url,
        requestId,
        details: error.details,
      });
    }

    if (error.validation) {
      return reply.status(422).send({
        type: 'about:blank',
        title: 'VALIDATION_ERROR',
        status: 422,
        detail: error.message,
        instance: request.url,
        requestId,
        details: error.validation,
      });
    }

    // Unhandled 500
    request.log.error(error, `Unhandled internal error on ${request.method} ${request.url}`);
    return reply.status(500).send({
      type: 'about:blank',
      title: 'INTERNAL_SERVER_ERROR',
      status: 500,
      detail: 'An unexpected internal error occurred.',
      instance: request.url,
      requestId,
    });
  });

  // Register Routes
  app.register(healthRoutes);
  app.register(teacherRoutes, { prefix: '/api/v1/teacher' });
  app.register(adminRoutes, { prefix: '/api/v1/admin' });

  // Root endpoint
  app.get('/', async () => {
    return {
      service: 'Qrie AI Application Backend',
      version: '0.1.0',
      status: 'healthy',
      environment: config.NODE_ENV,
    };
  });

  return app;
}
