/**
 * Test helper: build a Fastify app instance with an explicit configuration
 * object, bypassing the module-level `config` singleton (which reads from
 * the developer's `.env` file and is not suitable for deterministic tests).
 *
 * The helper mirrors `buildApp` from `src/app.ts` but accepts an explicit
 * `allowedOrigins` list so tests can verify different CORS configurations
 * without mutating `process.env`.
 */
import Fastify, { FastifyInstance } from 'fastify';
import cors from '@fastify/cors';
import jwt from '@fastify/jwt';
import sensible from '@fastify/sensible';
import crypto from 'crypto';
import { ZodError } from 'zod';
import { AppError } from '../../src/shared/errors.js';

interface TestConfig {
  allowedOrigins: string[];
  /** JWT secret; must be ≥ 32 chars. Defaults to a safe test value. */
  jwtSecret?: string;
  nodeEnv?: string;
}

const DEFAULT_JWT_SECRET = 'test_jwt_secret_at_least_32_chars_long!';

function buildCorsOrigin(
  allowedOrigins: string[],
  nodeEnv: string,
): string | string[] | false | ((origin: string | undefined, cb: (err: Error | null, allow: boolean) => void) => void) {
  if (allowedOrigins.length > 0) return allowedOrigins;
  if (nodeEnv === 'production') return false;
  return (origin, cb) => {
    if (!origin || /^https?:\/\/localhost(:\d+)?$/.test(origin)) {
      cb(null, true);
    } else {
      cb(null, false);
    }
  };
}

export function buildAppWithConfig(cfg: TestConfig): FastifyInstance {
  const { allowedOrigins, jwtSecret = DEFAULT_JWT_SECRET, nodeEnv = 'test' } = cfg;

  const app = Fastify({
    genReqId: (req) => {
      const existing = req.headers['x-request-id'];
      if (typeof existing === 'string') return existing;
      return `req_${crypto.randomUUID().replace(/-/g, '').slice(0, 16)}`;
    },
    requestIdHeader: 'x-request-id',
    logger: false,
  });

  app.register(cors, {
    origin: buildCorsOrigin(allowedOrigins, nodeEnv),
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Request-ID'],
    credentials: true,
  });
  app.register(sensible);
  app.register(jwt, { secret: jwtSecret });

  app.addHook('onSend', async (request, reply) => {
    reply.header('x-request-id', request.id);
  });

  app.setErrorHandler((error: any, request, reply) => {
    if (error instanceof AppError) {
      return reply.status(error.statusCode).send({ title: error.code, status: error.statusCode });
    }
    if (error instanceof ZodError) {
      return reply.status(422).send({ title: 'VALIDATION_ERROR', status: 422 });
    }
    const statusCode = typeof error?.statusCode === 'number' ? error.statusCode : 500;
    return reply.status(statusCode).send({ title: 'ERROR', status: statusCode });
  });

  app.setNotFoundHandler((request, reply) => {
    return reply.status(404).send({ title: 'NOT_FOUND', status: 404 });
  });

  app.get('/', async () => ({
    service: 'Qrie AI Application Backend',
    version: '0.1.0',
    status: 'healthy',
    environment: nodeEnv,
  }));

  return app;
}
