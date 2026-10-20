import { buildApp } from './app.js';
import { config } from './config/index.js';
import { Database } from './database/index.js';

const app = buildApp({
  logger: {
    level: config.LOG_LEVEL,
  },
});

async function start() {
  try {
    await app.listen({ port: config.PORT, host: config.HOST });
    app.log.info(`Qrie Backend listening on http://${config.HOST}:${config.PORT}`);
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }
}

// Graceful shutdown
const signals: NodeJS.Signals[] = ['SIGINT', 'SIGTERM'];
signals.forEach((signal) => {
  process.on(signal, async () => {
    app.log.info(`Received ${signal}, initiating graceful shutdown...`);
    try {
      await app.close();
      await Database.close();
      app.log.info('Graceful shutdown completed successfully.');
      process.exit(0);
    } catch (err) {
      app.log.error(err, 'Error during graceful shutdown');
      process.exit(1);
    }
  });
});

start();
