import http from 'http';
import { AddressInfo } from 'net';
import crypto from 'crypto';
import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import { LamAdapterClient } from '../src/modules/lam-integration/client.js';

describe('LAM Live HTTP Socket Simulator & E2E Verification', () => {
  let lamMockServer: http.Server;
  let lamBaseUrl: string;
  const testSecret = 'super_secret_test_jwt_key_32_characters_minimum!';
  const receivedEvents: any[] = [];
  const receivedTokens: string[] = [];

  beforeAll(async () => {
    lamMockServer = http.createServer((req, res) => {
      const authHeader = req.headers['authorization'] || '';
      receivedTokens.push(authHeader);

      let body = '';
      req.on('data', (chunk) => {
        body += chunk;
      });

      req.on('end', () => {
        const parsed = body ? JSON.parse(body) : {};

        // Verify JWT format: Bearer header.payload.sig
        const tokenMatch = authHeader.match(/^Bearer\s+([A-Za-z0-9-_]+)\.([A-Za-z0-9-_]+)\.([A-Za-z0-9-_]+)$/);
        if (!tokenMatch) {
          res.writeHead(401, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify({ error: 'Invalid or missing Bearer token' }));
          return;
        }

        const [, headerB64, payloadB64, sig] = tokenMatch;
        const expectedSig = crypto
          .createHmac('sha256', testSecret)
          .update(`${headerB64}.${payloadB64}`)
          .digest('base64url');

        if (sig !== expectedSig) {
          res.writeHead(403, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify({ error: 'Signature mismatch' }));
          return;
        }

        const tokenPayload = JSON.parse(Buffer.from(payloadB64, 'base64url').toString('utf8'));
        if (tokenPayload.iss !== 'lam-auth' || tokenPayload.aud !== 'lam-service') {
          res.writeHead(401, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify({ error: 'Issuer/Audience mismatch' }));
          return;
        }

        // Endpoint routing
        if (req.method === 'POST' && req.url === '/v1/events') {
          receivedEvents.push(parsed);
          res.writeHead(200, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify({ status: 'ingested', event_id: parsed.event_id }));
          return;
        }

        if (req.method === 'POST' && req.url === '/v1/recommendations') {
          res.writeHead(200, { 'Content-Type': 'application/json' });
          res.end(
            JSON.stringify({
              recommendation_id: `rec_lam_${Date.now()}`,
              action_type: 'scaffold_substep',
              target_concept_id: parsed.concept_id,
              assistance_level: 2,
              priority_tier: 'tier_active_struggle',
              reason_code: 'CONSECUTIVE_UNASSISTED_FAILURES',
              suggested_strategy: 'break_down_substeps',
              rationale: 'Learner experienced 3 consecutive failures on rational number division.',
              policy_version: 'lam-policy-v2.1',
              safe_fallback: false,
              uncertainty: 0.12,
            })
          );
          return;
        }

        res.writeHead(404, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Not found' }));
      });
    });

    await new Promise<void>((resolve) => {
      lamMockServer.listen(0, '127.0.0.1', () => resolve());
    });

    const addr = lamMockServer.address() as AddressInfo;
    lamBaseUrl = `http://127.0.0.1:${addr.port}`;
  });

  afterAll(async () => {
    await new Promise<void>((resolve) => {
      lamMockServer.close(() => resolve());
    });
  });

  it('successfully forwards event across real TCP socket to LAM with verified JWT', async () => {
    const client = new LamAdapterClient(lamBaseUrl, testSecret, 3000);
    const eventPayload = {
      event_id: 'evt_socket_test_01',
      student_id: 'std_aarav',
      session_id: 'sess_socket_01',
      concept_ids: ['math.fractions.division'],
      item_id: 'q_div_01',
      timestamp: new Date().toISOString(),
      event_type: 'attempt' as const,
      correctness: false,
      assistance_level: 0,
    };

    const res = await client.forwardEvent('sch_delhi_dps', eventPayload);

    expect(res.status).toBe('ingested');
    expect(res.event_id).toBe('evt_socket_test_01');
    expect(receivedEvents).toHaveLength(1);
    expect(receivedEvents[0].event_id).toBe('evt_socket_test_01');
    expect(receivedEvents[0].concept_ids).toEqual(['math.fractions.division']);
  });

  it('receives authentic model-derived recommendation with safe_fallback === false', async () => {
    const client = new LamAdapterClient(lamBaseUrl, testSecret, 3000);

    const rec = await client.getRecommendation('sch_delhi_dps', {
      student_id: 'std_aarav',
      concept_id: 'math.fractions.division',
      consecutive_failures: 3,
    });

    expect(rec.safe_fallback).toBe(false);
    expect(rec.action_type).toBe('scaffold_substep');
    expect(rec.reason_code).toBe('CONSECUTIVE_UNASSISTED_FAILURES');
    expect(rec.assistance_level).toBe(2);
    expect(rec.uncertainty).toBe(0.12);
  });

  it('engages circuit breaker and safe fallback when LAM server stops responding', async () => {
    // Point client to dead port
    const deadClient = new LamAdapterClient('http://127.0.0.1:1', testSecret, 500);

    const rec = await deadClient.getRecommendation('sch_delhi_dps', {
      student_id: 'std_aarav',
      concept_id: 'math.fractions.division',
    });

    expect(rec.safe_fallback).toBe(true);
    expect(rec.reason_code).toBe('LAM_UNREACHABLE_FALLBACK');
  });
});
