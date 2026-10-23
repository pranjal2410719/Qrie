import { describe, it, expect } from 'vitest';
import { parseConfig } from '../src/config/index.js';

const DEV_JWT_SECRET = 'qrie_development_jwt_secret_must_be_at_least_32_characters_long!';
const DEV_LAM_SECRET = 'staging_super_secret_jwt_key_at_least_32_characters_long!';
const DEV_DATABASE_URL = 'postgresql://postgres:postgres@localhost:5432/postgres';

function productionEnv(overrides: Record<string, string> = {}) {
  return {
    NODE_ENV: 'production',
    JWT_SECRET: 'j'.repeat(48),
    LAM_JWT_SECRET: 'l'.repeat(48),
    DATABASE_URL: 'postgresql://qrie:secret@db.internal:5432/qrie',
    ALLOW_DEMO_AUTH: 'false',
    ...overrides,
  } as NodeJS.ProcessEnv;
}

describe('Production configuration guard', () => {
  it('accepts a hardened production configuration', () => {
    const config = parseConfig(productionEnv());
    expect(config.NODE_ENV).toBe('production');
    expect(config.ALLOW_DEMO_AUTH).toBe(false);
  });

  it('refuses to start with the development JWT secret', () => {
    expect(() => parseConfig(productionEnv({ JWT_SECRET: DEV_JWT_SECRET }))).toThrow(/JWT_SECRET/);
  });

  it('refuses to start with the development LAM secret', () => {
    expect(() => parseConfig(productionEnv({ LAM_JWT_SECRET: DEV_LAM_SECRET }))).toThrow(/LAM_JWT_SECRET/);
  });

  it('refuses to start with the development database URL', () => {
    expect(() => parseConfig(productionEnv({ DATABASE_URL: DEV_DATABASE_URL }))).toThrow(/DATABASE_URL/);
  });

  it('refuses demo session minting in production', () => {
    expect(() => parseConfig(productionEnv({ ALLOW_DEMO_AUTH: 'true' }))).toThrow(/ALLOW_DEMO_AUTH/);
  });

  it('still permits development defaults outside production', () => {
    const config = parseConfig({ NODE_ENV: 'development' } as NodeJS.ProcessEnv);
    expect(config.JWT_SECRET).toBe(DEV_JWT_SECRET);
    expect(config.ALLOW_DEMO_AUTH).toBe(true);
  });
});
