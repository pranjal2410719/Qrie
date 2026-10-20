import { z } from 'zod';
import dotenv from 'dotenv';

dotenv.config();

const configSchema = z.object({
  PORT: z.coerce.number().default(4000),
  HOST: z.string().default('0.0.0.0'),
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
  LOG_LEVEL: z.string().default('info'),

  DATABASE_URL: z.string().url().default('postgresql://postgres:postgres@localhost:5432/postgres'),

  JWT_SECRET: z.string().min(32).default('qrie_development_jwt_secret_must_be_at_least_32_characters_long!'),
  JWT_ISSUER: z.string().default('qrie-auth'),
  JWT_AUDIENCE: z.string().default('qrie-api'),

  LAM_BASE_URL: z.string().url().default('http://localhost:8000'),
  LAM_JWT_SECRET: z.string().min(32).default('staging_super_secret_jwt_key_at_least_32_characters_long!'),
});

export type Config = z.infer<typeof configSchema>;

export const config: Config = configSchema.parse(process.env);
