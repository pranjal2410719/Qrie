import { FastifyInstance } from 'fastify';
import { Database } from '../../database/index.js';

export async function healthRoutes(app: FastifyInstance) {
  app.get('/health/live', async (_req, reply) => {
    return reply.status(200).send({ status: 'alive' });
  });

  app.get('/health/ready', async (_req, reply) => {
    const isDbConnected = await Database.healthCheck();
    if (!isDbConnected) {
      return reply.status(503).send({
        status: 'unavailable',
        database: 'disconnected',
      });
    }

    return reply.status(200).send({
      status: 'ready',
      database: 'connected',
    });
  });
}
