/**
 * CORS configuration tests.
 *
 * These tests use the actual `buildApp` factory so they verify the real
 * application CORS behaviour, not a separate Fastify instance with a different
 * configuration.
 *
 * The tests inject into the real app using Fastify's built-in `.inject()` API;
 * no network connection or external HTTP client is required.
 *
 * We use `parseConfig` + `buildApp` together so the CORS origin option is
 * resolved from a known environment, independent of whatever the developer has
 * set in their local `.env`.
 */
import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import { FastifyInstance } from 'fastify';

// We build a custom app instance with known ALLOWED_ORIGINS so the test is
// deterministic regardless of the developer's local environment.
// We do NOT import the module-level `buildApp` directly (which reads from the
// already-parsed `config` singleton) because that singleton picks up the
// developer's local .env.  Instead, we re-export a helper that accepts
// explicit origins so the app factory is testable in isolation.

import { buildAppWithConfig } from './helpers/build_app_with_config.js';

let allowedApp: FastifyInstance;
let noOriginsApp: FastifyInstance;

beforeAll(async () => {
  allowedApp = buildAppWithConfig({ allowedOrigins: ['https://allowed.example.com'] });
  await allowedApp.ready();

  noOriginsApp = buildAppWithConfig({ allowedOrigins: [] });
  await noOriginsApp.ready();
});

afterAll(async () => {
  await allowedApp.close();
  await noOriginsApp.close();
});

describe('CORS – allowed origin', () => {
  it('reflects the allowed origin in the response header', async () => {
    const res = await allowedApp.inject({
      method: 'GET',
      url: '/',
      headers: { origin: 'https://allowed.example.com' },
    });
    expect(res.headers['access-control-allow-origin']).toBe('https://allowed.example.com');
  });

  it('returns 200 for a simple GET from an allowed origin', async () => {
    const res = await allowedApp.inject({
      method: 'GET',
      url: '/',
      headers: { origin: 'https://allowed.example.com' },
    });
    expect(res.statusCode).toBe(200);
  });
});

describe('CORS – disallowed origin', () => {
  it('does NOT reflect a disallowed origin', async () => {
    const res = await allowedApp.inject({
      method: 'GET',
      url: '/',
      headers: { origin: 'https://evil.example.com' },
    });
    // @fastify/cors sets the header to 'false' (the string) or omits it for
    // rejected origins depending on configuration. Either way it must not echo
    // the attacker origin back.
    const acao = res.headers['access-control-allow-origin'];
    expect(acao).not.toBe('https://evil.example.com');
  });
});

describe('CORS – no Origin header', () => {
  it('responds normally to requests without an Origin header', async () => {
    const res = await allowedApp.inject({
      method: 'GET',
      url: '/',
    });
    expect(res.statusCode).toBe(200);
  });
});

describe('CORS – preflight (OPTIONS)', () => {
  it('responds to a preflight request from an allowed origin', async () => {
    const res = await allowedApp.inject({
      method: 'OPTIONS',
      url: '/',
      headers: {
        origin: 'https://allowed.example.com',
        'access-control-request-method': 'POST',
        'access-control-request-headers': 'Content-Type',
      },
    });
    // A valid preflight must return 204 or 200 with the CORS headers.
    expect([200, 204]).toContain(res.statusCode);
    expect(res.headers['access-control-allow-origin']).toBe('https://allowed.example.com');
    expect(res.headers['access-control-allow-methods']).toBeDefined();
  });

  it('does NOT approve a preflight from a disallowed origin', async () => {
    const res = await allowedApp.inject({
      method: 'OPTIONS',
      url: '/',
      headers: {
        origin: 'https://evil.example.com',
        'access-control-request-method': 'POST',
      },
    });
    const acao = res.headers['access-control-allow-origin'];
    expect(acao).not.toBe('https://evil.example.com');
  });
});

describe('CORS – production with empty ALLOWED_ORIGINS', () => {
  it('denies cross-origin requests when no origins are configured', async () => {
    const res = await noOriginsApp.inject({
      method: 'GET',
      url: '/',
      headers: { origin: 'https://some-origin.example.com' },
    });
    const acao = res.headers['access-control-allow-origin'];
    // Should not reflect the attacker origin.
    expect(acao).not.toBe('https://some-origin.example.com');
  });
});
