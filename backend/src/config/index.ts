import { z } from 'zod';
import dotenv from 'dotenv';

dotenv.config();

/**
 * Development-only defaults.
 *
 * These exist so a fresh clone can boot without a `.env`, and they are safe
 * ONLY because `superRefine` below refuses to start in production while any
 * of them is still in effect. Keeping them in one named object (instead of
 * inline literals) is what makes that comparison reliable.
 */
const DEV_DEFAULTS = {
  DATABASE_URL: 'postgresql://postgres:postgres@localhost:5432/postgres',
  JWT_SECRET: 'qrie_development_jwt_secret_must_be_at_least_32_characters_long!',
  LAM_JWT_SECRET: 'staging_super_secret_jwt_key_at_least_32_characters_long!',
} as const;

const configSchema = z
  .object({
    PORT: z.coerce.number().default(4000),
    HOST: z.string().default('0.0.0.0'),
    NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
    LOG_LEVEL: z.string().default('info'),

    DATABASE_URL: z.string().url().default(DEV_DEFAULTS.DATABASE_URL),

    JWT_SECRET: z.string().min(32).default(DEV_DEFAULTS.JWT_SECRET),
    JWT_ISSUER: z.string().default('qrie-auth'),
    JWT_AUDIENCE: z.string().default('qrie-api'),

    LAM_BASE_URL: z.string().url().default('http://localhost:8000'),
    LAM_JWT_SECRET: z.string().min(32).default(DEV_DEFAULTS.LAM_JWT_SECRET),

    /**
     * Day 2 relay behaviour. Persisting an event is the durable part; relaying
     * it to LAM is best-effort and must never fail the client's sync. Set
     * `LAM_RELAY_ENABLED=false` for a local run with no LAM service.
     */
    LAM_RELAY_ENABLED: z
      .enum(['true', 'false'])
      .default('true')
      .transform((value) => value === 'true'),
    LAM_TIMEOUT_MS: z.coerce.number().int().min(100).max(30000).default(2000),

    /**
     * The current `POST /auth/session` endpoint mints a demo JWT without
     * verifying any credential. It is useful for local UI work and must never
     * be reachable in production, so it is explicit, default-on only for local
     * development, and rejected by the production guard below.
     */
    ALLOW_DEMO_AUTH: z
      .enum(['true', 'false'])
      .default('true')
      .transform((value) => value === 'true'),

    /**
     * Comma-separated list of origins that are allowed to make cross-origin
     * requests.  Example: "https://app.qrie.in,https://staging.qrie.in"
     *
     * In development an empty value is treated as "allow localhost:* only"
     * so a fresh clone works without extra configuration.  In production this
     * must be explicitly set; the superRefine guard below rejects an empty
     * list when NODE_ENV === 'production'.
     *
     * Origins are trimmed and empty strings are filtered out, so trailing
     * commas and extra spaces are harmless.
     */
    ALLOWED_ORIGINS: z
      .string()
      .default('')
      .transform((val) =>
        val
          .split(',')
          .map((s) => s.trim())
          .filter((s) => s.length > 0),
      ),
  })
  .superRefine((cfg, ctx) => {
    if (cfg.NODE_ENV !== 'production') return;

    if (cfg.JWT_SECRET === DEV_DEFAULTS.JWT_SECRET) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ['JWT_SECRET'],
        message: 'JWT_SECRET is the development default; set a unique production secret.',
      });
    }
    if (cfg.LAM_JWT_SECRET === DEV_DEFAULTS.LAM_JWT_SECRET) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ['LAM_JWT_SECRET'],
        message: 'LAM_JWT_SECRET is the development default; set a unique production secret.',
      });
    }
    if (cfg.DATABASE_URL === DEV_DEFAULTS.DATABASE_URL) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ['DATABASE_URL'],
        message: 'DATABASE_URL is the development default; point it at the production database.',
      });
    }
    if (cfg.ALLOW_DEMO_AUTH) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ['ALLOW_DEMO_AUTH'],
        message: 'ALLOW_DEMO_AUTH must be false in production; demo session minting has no credential check.',
      });
    }
    if (cfg.ALLOWED_ORIGINS.length === 0) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ['ALLOWED_ORIGINS'],
        message:
          'ALLOWED_ORIGINS must contain at least one origin in production. Set a comma-separated list of allowed origins.',
      });
    }
  });

export type Config = z.infer<typeof configSchema>;

/**
 * Parses and validates configuration. Exported so the production guard can be
 * exercised by tests without mutating `process.env` for the whole suite.
 */
export function parseConfig(env: NodeJS.ProcessEnv = process.env): Config {
  const parsed = configSchema.safeParse(env);
  if (!parsed.success) {
    const issues = parsed.error.issues
      .map((issue) => `  - ${issue.path.join('.') || '(root)'}: ${issue.message}`)
      .join('\n');
    throw new Error(`Invalid configuration:\n${issues}`);
  }
  return parsed.data;
}

export const config: Config = parseConfig();
