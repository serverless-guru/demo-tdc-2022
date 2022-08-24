import fastify from 'fastify';

const server = fastify({ logger: false });

process.on('uncaughtException', () => {
  // eslint-disable-next-line no-console
  console.log('Uncaught Exception');
  process.exit(1);
});

process.on('unhandledRejection', async () => {
  // eslint-disable-next-line no-console
  console.log('Unhandled Rejection');
  await server.close();
  process.exit(1);
});

process.on('SIGINT', async () => {
  // eslint-disable-next-line no-console
  console.log('Container asked to stop');
  await server.close();
  process.exit(0);
});

process.once('SIGTERM', async () => {
  // eslint-disable-next-line no-console
  console.log('Container asked to stop');
  await server.close();
  process.exit(0);
});

process.on('exit', () => {
  // eslint-disable-next-line no-console
  console.log('Exiting Process');
});

// eslint-disable-next-line require-await
server.get('/health-status', async (request, reply) => {
  return reply.code(200).send({ message: 'success' });
});


/**
 * Starts the server
 */
export async function startServer(): Promise<void> {
  try {
    await server.listen({
      port: 8080,
      host: '0.0.0.0',
    });
    // eslint-disable-next-line no-console
    console.log('Listening on port 8080');
  } catch (err) {
    // eslint-disable-next-line no-console
    console.error('Failed to boot up', err as Error);
    throw err;
  }
}
