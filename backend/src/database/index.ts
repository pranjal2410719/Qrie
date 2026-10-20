import pg from 'pg';
import { config } from '../config/index.js';

const { Pool } = pg;

export class Database {
  private static pool: pg.Pool | null = null;

  public static getPool(): pg.Pool {
    if (!this.pool) {
      this.pool = new Pool({
        connectionString: config.DATABASE_URL,
        max: 20,
        idleTimeoutMillis: 30000,
        connectionTimeoutMillis: 5000,
      });

      this.pool.on('error', (err) => {
        console.error('Unexpected error on idle PostgreSQL client', err);
      });
    }
    return this.pool;
  }

  public static async query<T extends pg.QueryResultRow = any>(
    text: string,
    params?: any[]
  ): Promise<pg.QueryResult<T>> {
    const pool = this.getPool();
    return pool.query<T>(text, params);
  }

  public static async healthCheck(): Promise<boolean> {
    try {
      const pool = this.getPool();
      const res = await pool.query('SELECT 1 as healthy');
      return res.rows[0]?.healthy === 1;
    } catch {
      return false;
    }
  }

  public static async close(): Promise<void> {
    if (this.pool) {
      await this.pool.end();
      this.pool = null;
    }
  }
}
