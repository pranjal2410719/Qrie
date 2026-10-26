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

  /**
   * Operational Status & Health Metrics
   */
  app.get('/health/status', async (_req, reply) => {
    const isDbConnected = await Database.healthCheck();
    const queueStats = { pending: 0, failed: 0, relayed: 0 };

    if (isDbConnected) {
      try {
        const res = await Database.query<{ relay_status: string; count: string }>(
          `select relay_status, count(*) as count from public.sync_event group by relay_status`,
          [],
        );
        for (const row of res.rows) {
          if (row.relay_status in queueStats) {
            (queueStats as any)[row.relay_status] = parseInt(row.count, 10);
          }
        }
      } catch {
        // Table may not exist yet in test environment
      }
    }

    return reply.status(200).send({
      service: 'Qrie AI Application Backend',
      version: '0.1.0',
      status: isDbConnected ? 'ready' : 'degraded',
      database: isDbConnected ? 'connected' : 'disconnected',
      outbox_backlog: queueStats,
      timestamp: new Date().toISOString(),
    });
  });
}
