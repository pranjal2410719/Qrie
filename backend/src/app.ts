import Fastify, { FastifyInstance, FastifyServerOptions } from 'fastify';
import cors from '@fastify/cors';
import jwt from '@fastify/jwt';
import sensible from '@fastify/sensible';
import crypto from 'crypto';
import { ZodError } from 'zod';

import { config } from './config/index.js';
import { AppError } from './shared/errors.js';
import { healthRoutes } from './modules/health/routes.js';
import { teacherRoutes } from './modules/teacher/routes.js';
import { adminRoutes } from './modules/admin/routes.js';
import { studentRoutes } from './modules/student/routes.js';

/**
 * Build the CORS origin option from the configured allowlist.
 *
 * Rules:
 *  - Production with an explicit list → only those origins are reflected back.
 *  - Development/test with an explicit list → same, respect the list.
 *  - Development/test with an empty list → allow localhost on any port so
 *    a fresh clone works without extra configuration.
 *  - Production with an empty list → the config layer already throws, so this
 *    branch should never be reached; we default to `false` (deny all) as a
 *    belt-and-suspenders guard.
 */
function buildCorsOrigin(
  allowedOrigins: string[],
  nodeEnv: string,
): string | string[] | false | ((origin: string | undefined, cb: (err: Error | null, allow: boolean) => void) => void) {
  if (allowedOrigins.length > 0) {
    return allowedOrigins;
  }
  if (nodeEnv === 'production') {
    // Config validation should have already thrown, but be explicit here.
    return false;
  }
  // Development / test: allow localhost on any port without requiring explicit config.
  return (origin, cb) => {
    if (!origin || /^https?:\/\/localhost(:\d+)?$/.test(origin)) {
      cb(null, true);
    } else {
      cb(null, false);
    }
  };
}

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
  app.register(cors, {
    origin: buildCorsOrigin(config.ALLOWED_ORIGINS, config.NODE_ENV),
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Request-ID'],
    credentials: true,
  });
  app.register(sensible);
  app.register(jwt, {
    secret: config.JWT_SECRET,
    sign: {
      iss: config.JWT_ISSUER,
      aud: config.JWT_AUDIENCE,
    },
    verify: {
      allowedIss: config.JWT_ISSUER,
      allowedAud: config.JWT_AUDIENCE,
    },
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

    // Handlers use `schema.parse`, which throws ZodError rather than the
    // Fastify `validation` shape. Without this branch a bad request body is
    // reported as a 500 outage.
    if (error instanceof ZodError) {
      return reply.status(422).send({
        type: 'about:blank',
        title: 'VALIDATION_ERROR',
        status: 422,
        detail: 'Request body failed validation',
        instance: request.url,
        requestId,
        details: error.issues.map((issue) => ({
          path: issue.path.join('.'),
          message: issue.message,
        })),
      });
    }

    // Client errors raised by Fastify itself (malformed JSON, unsupported media
    // type, payload too large, ...) must keep their 4xx status. Collapsing them
    // into 500 hides a caller mistake and reports a false outage.
    const statusCode = typeof error?.statusCode === 'number' ? error.statusCode : 500;
    if (statusCode >= 400 && statusCode < 500) {
      return reply.status(statusCode).send({
        type: 'about:blank',
        title: error.code || 'REQUEST_ERROR',
        status: statusCode,
        detail: error.message,
        instance: request.url,
        requestId,
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

  // Unknown routes use the same RFC 7807 envelope as every other error.
  app.setNotFoundHandler((request, reply) => {
    return reply.status(404).send({
      type: 'about:blank',
      title: 'NOT_FOUND',
      status: 404,
      detail: `Route ${request.method}:${request.url} not found`,
      instance: request.url,
      requestId: request.id,
    });
  });

  // Register Routes
  app.register(healthRoutes);
  app.register(teacherRoutes, { prefix: '/api/v1/teacher' });
  app.register(adminRoutes, { prefix: '/api/v1/admin' });
  app.register(studentRoutes, { prefix: '/api/v1' });

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
