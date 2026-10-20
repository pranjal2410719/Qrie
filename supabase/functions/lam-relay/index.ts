// @ts-nocheck — Deno runtime for Supabase Edge Functions.
/**
 * SUPABASE EDGE FUNCTION: lam-relay
 *
 * Server-side trusted bridge between Qrie students and LAM.
 *
 * Responsibilities:
 * 1. Authenticate student via Supabase token (Authorization: Bearer <token>).
 * 2. Look up student's authorized organization (tenant) from public.membership.
 * 3. Enforce tenant isolation — student cannot forge tenant ID.
 * 4. Sign privileged LAM token in memory using LAM_JWT_SECRET.
 * 5. Forward verified learning events to LAM POST /v1/events.
 * 6. Query next-action recommendations from LAM POST /v1/recommendations.
 * 7. On LAM outage, return deterministic safe fallback without fabricating mastery.
 *
 * Deploy:
 *   supabase functions deploy lam-relay --no-verify-jwt
 */

import {
  createSupabaseVerifier,
  bearerFrom,
} from './auth.ts';
import {
  LamTransportClient,
  createSafeFallbackPlan,
} from './lamRelay.ts';

const env = (name: string): string => Deno.env.get(name) ?? '';

const SUPABASE_URL = env('SUPABASE_URL');
const ANON_KEY = env('SUPABASE_ANON_KEY');
const SERVICE_ROLE_KEY = env('SUPABASE_SERVICE_ROLE_KEY');
const LAM_BASE_URL = env('LAM_BASE_URL') || 'http://localhost:8000';
const LAM_JWT_SECRET = env('LAM_JWT_SECRET');

const CORS = {
  'access-control-allow-origin': '*',
  'access-control-allow-headers': 'authorization, content-type, x-session-id, x-tenant-id',
  'access-control-allow-methods': 'GET, POST, OPTIONS',
  'access-control-max-age': '86400',
};

const verify = createSupabaseVerifier(SUPABASE_URL, ANON_KEY);

/**
 * Resolve student's authorized organization (tenant) using service role.
 */
async function resolveStudentOrg(userId: string): Promise<string | null> {
  const url = `${SUPABASE_URL}/rest/v1/membership?select=org_id&user_id=eq.${userId}&limit=1`;
  const res = await fetch(url, {
    headers: {
      apikey: SERVICE_ROLE_KEY,
      authorization: `Bearer ${SERVICE_ROLE_KEY}`,
      accept: 'application/json',
    },
  });
  if (!res.ok) return null;
  const rows = (await res.json().catch(() => [])) as Array<{ org_id: string }>;
  return rows[0]?.org_id ?? null;
}

Deno.serve(async (req: Request) => {
  const requestId = `req_${crypto.randomUUID()}`;

  if (req.method === 'OPTIONS') {
    return new Response(null, { status: 204, headers: CORS });
  }

  const url = new URL(req.url);
  const path = url.pathname.replace(/\/+$/, '');

  // Liveness / readiness check
  if (req.method === 'GET' && (path.endsWith('/health') || path === '')) {
    return new Response(
      JSON.stringify({
        status: 'ok',
        relay: 'lam-relay',
        version: '1.0.0',
        lam_configured: Boolean(LAM_JWT_SECRET && LAM_BASE_URL),
        request_id: requestId,
      }),
      { status: 200, headers: { 'content-type': 'application/json', ...CORS } },
    );
  }

  // 1. Authenticate caller
  const authHeader = req.headers.get('authorization') || undefined;
  const authResult = await verify(authHeader);
  if (!authResult.ok) {
    return new Response(
      JSON.stringify({
        error: {
          code: 'UNAUTHORIZED',
          message: authResult.why,
          request_id: requestId,
        },
      }),
      { status: authResult.status, headers: { 'content-type': 'application/json', ...CORS } },
    );
  }

  const userId = authResult.user.userId;

  // 2. Resolve tenant membership (org_id)
  const orgId = await resolveStudentOrg(userId);
  if (!orgId) {
    return new Response(
      JSON.stringify({
        error: {
          code: 'NO_TENANT_MEMBERSHIP',
          message: 'Student account has no registered organization membership.',
          request_id: requestId,
        },
      }),
      { status: 403, headers: { 'content-type': 'application/json', ...CORS } },
    );
  }

  // Validate optional client-supplied tenant header to prevent tenant spoofing
  const clientTenantHeader = req.headers.get('x-tenant-id');
  if (clientTenantHeader && clientTenantHeader !== orgId) {
    return new Response(
      JSON.stringify({
        error: {
          code: 'TENANT_MISMATCH',
          message: 'Client-supplied tenant header does not match authenticated membership.',
          request_id: requestId,
        },
      }),
      { status: 403, headers: { 'content-type': 'application/json', ...CORS } },
    );
  }

  // 3. Verify server secrets
  if (!LAM_JWT_SECRET) {
    return new Response(
      JSON.stringify({
        error: {
          code: 'RELAY_UNCONFIGURED',
          message: 'LAM relay server secret (LAM_JWT_SECRET) is unconfigured.',
          request_id: requestId,
        },
      }),
      { status: 503, headers: { 'content-type': 'application/json', ...CORS } },
    );
  }

  const client = new LamTransportClient({
    lamBaseUrl: LAM_BASE_URL,
    lamSecret: LAM_JWT_SECRET,
  });

  try {
    const bodyText = await req.text();
    const body = bodyText ? JSON.parse(bodyText) : {};

    // 4. Route POST /events
    if (req.method === 'POST' && path.endsWith('/events')) {
      const event = body.event || body;
      if (!event || !event.id) {
        return new Response(
          JSON.stringify({
            error: {
              code: 'INVALID_PAYLOAD',
              message: 'Request body must contain a valid learning event with an id.',
              request_id: requestId,
            },
          }),
          { status: 422, headers: { 'content-type': 'application/json', ...CORS } },
        );
      }

      const result = await client.forwardEvent(event, orgId, userId);
      return new Response(
        JSON.stringify({ status: 'ok', data: result, request_id: requestId }),
        { status: 200, headers: { 'content-type': 'application/json', ...CORS } },
      );
    }

    // 5. Route POST /recommendations
    if (req.method === 'POST' && path.endsWith('/recommendations')) {
      const conceptId = body.concept_id || body.conceptId;
      if (!conceptId || typeof conceptId !== 'string') {
        return new Response(
          JSON.stringify({
            error: {
              code: 'INVALID_PAYLOAD',
              message: 'Request body must specify concept_id as a string.',
              request_id: requestId,
            },
          }),
          { status: 422, headers: { 'content-type': 'application/json', ...CORS } },
        );
      }

      const plan = await client.getRecommendation(orgId, userId, conceptId, {
        consecutiveFailures: body.consecutive_failures ?? body.consecutiveFailures,
        activeMisconceptionId: body.active_misconception_id ?? body.activeMisconceptionId,
        misconceptionStatus: body.misconception_status ?? body.misconceptionStatus,
        prerequisiteReadiness: body.prerequisite_readiness ?? body.prerequisiteReadiness,
      });

      return new Response(
        JSON.stringify({ status: 'ok', data: plan, request_id: requestId }),
        { status: 200, headers: { 'content-type': 'application/json', ...CORS } },
      );
    }

    return new Response(
      JSON.stringify({
        error: {
          code: 'NOT_FOUND',
          message: `Unknown relay endpoint: ${req.method} ${path}`,
          request_id: requestId,
        },
      }),
      { status: 404, headers: { 'content-type': 'application/json', ...CORS } },
    );
  } catch (err) {
    const errorMsg = (err as Error).message || 'Internal relay error';
    return new Response(
      JSON.stringify({
        error: {
          code: 'RELAY_PROCESSING_ERROR',
          message: errorMsg,
          request_id: requestId,
        },
      }),
      { status: 502, headers: { 'content-type': 'application/json', ...CORS } },
    );
  }
});
