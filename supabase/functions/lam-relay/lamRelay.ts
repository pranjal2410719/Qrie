/**
 * QRIE – LAM TRUSTED RELAY
 *
 * Implements the secure, authenticated server-side bridge between Qrie
 * and the Learning Adaptation Model (LAM).
 *
 * Non-negotiable architectural rules:
 * 1. The client browser / app NEVER receives the privileged LAM signing secret.
 * 2. Caller authentication is verified through Supabase auth before any LAM call.
 * 3. Tenant (organization) identity is derived strictly from server-side database
 *    membership (the student's org_id), never trusted from client-supplied headers.
 * 4. Missing signals (correctness = null) are preserved and never coerced to false.
 * 5. Bounded retries with exponential backoff on transient 502/503/504 errors.
 * 6. Fast-fail on terminal 401/403/409/422 responses.
 * 7. On LAM outage, events remain safely stored in the client/server outbox and
 *    a safe fallback plan is returned without fabricating mastery or BKT updates.
 */

export interface LedgerEvent {
  id: string;
  sessionId: string;
  seq?: number;
  at: string;
  kind: string;
  source?: string;
  surface?: string;
  outcomeIds: string[];
  topicRef?: string;
  payload: Record<string, unknown>;
}

export interface LamRelayConfig {
  lamBaseUrl: string;
  lamSecret: string;
  issuer?: string;
  audience?: string;
  connectTimeoutMs?: number;
  readTimeoutMs?: number;
  maxRetries?: number;
}

export interface LamIngestResult {
  status: 'ingested' | 'duplicate';
  eventId: string;
  tenantId: string;
  studentId: string;
  affectedConceptIds: string[];
  ingestedAt: string;
  message?: string;
}

export type QrieActivityType =
  | 'teacher_help'
  | 'prerequisite_review'
  | 'diagnostic_question'
  | 'retrieval_challenge'
  | 'mastery_check'
  | 'next_concept'
  | 'worked_example'
  | 'scaffolded_problem'
  | 'standard_practice';

export interface QrieExecutionPlan {
  activityType: QrieActivityType;
  assistanceRung: number;
  targetConceptId: string;
  rationale: string;
  policyVersion: string;
  isSafeFallback: boolean;
  recommendationId?: string;
  priorityTier?: string;
  uncertainty?: number;
}

export interface LamRecommendationPayload {
  recommendation_id: string;
  action_type: string;
  target_concept_id: string;
  assistance_level: number;
  priority_tier: string;
  reason_code: string;
  suggested_strategy?: string | null;
  rationale: string;
  policy_version: string;
  safe_fallback?: boolean;
  uncertainty?: number | null;
  relevant_learner_state_version?: number | null;
  metadata?: Record<string, unknown>;
}

/**
 * Base64URL encoder conforming to RFC 7515 without padding.
 */
export function base64UrlEncode(bytes: Uint8Array): string {
  let binary = '';
  for (let i = 0; i < bytes.length; i++) {
    binary += String.fromCharCode(bytes[i]);
  }
  return btoa(binary).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
}

/**
 * Cryptographically sign an HMAC-SHA256 JWT using Web Crypto API.
 * Portable across Node.js 18+, Deno, and Edge environments without external deps.
 */
export async function signLamToken(
  tenantId: string,
  userId: string,
  secret: string,
  options: {
    issuer?: string;
    audience?: string;
    ttlSeconds?: number;
    roles?: string[];
    now?: () => number;
  } = {},
): Promise<string> {
  const enc = new TextEncoder();
  const nowSec = Math.floor((options.now ? options.now() : Date.now()) / 1000);
  const ttl = options.ttlSeconds ?? 300; // 5 minutes default

  const header = { alg: 'HS256', typ: 'JWT' };
  const payload = {
    sub: userId,
    tenant_id: tenantId,
    tid: tenantId,
    roles: options.roles ?? ['service'],
    iat: nowSec,
    exp: nowSec + ttl,
    iss: options.issuer ?? 'lam-service',
    aud: options.audience ?? 'lam-api',
  };

  const headerPart = base64UrlEncode(enc.encode(JSON.stringify(header)));
  const payloadPart = base64UrlEncode(enc.encode(JSON.stringify(payload)));
  const data = `${headerPart}.${payloadPart}`;

  const key = await crypto.subtle.importKey(
    'raw',
    enc.encode(secret),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign'],
  );
  const sig = await crypto.subtle.sign('HMAC', key, enc.encode(data));
  const sigPart = base64UrlEncode(new Uint8Array(sig));

  return `${data}.${sigPart}`;
}

/**
 * Map Qrie LedgerEvent to LAM EventIngestRequest payload.
 */
export function mapLedgerEventToLam(
  event: LedgerEvent,
  authenticatedStudentId: string,
): Record<string, unknown> {
  const payload = (event.payload || {}) as Record<string, unknown>;
  const rung = typeof payload.assistanceRung === 'number' ? payload.assistanceRung : 0;
  const hints = typeof payload.hintsShown === 'number' ? payload.hintsShown : 0;
  const isAssisted = rung > 0 || hints > 0;

  // Determine event_type
  let eventType = 'attempt';
  if (event.kind === 'helped') eventType = 'hint';
  else if (event.kind === 'taught') eventType = 'explanation';
  else if (event.kind === 'reflected') eventType = 'assessment';

  // Determine correctness with strict non-coercion
  let correctness: boolean | null = null;
  if (event.kind === 'answered' && typeof payload.correct === 'boolean') {
    correctness = payload.correct;
  }

  // Canonical concept IDs
  let concepts = event.outcomeIds;
  if (!concepts || concepts.length === 0) {
    concepts = event.topicRef ? [event.topicRef] : ['general'];
  }

  const itemId =
    (payload.probeId as string) ||
    (payload.beatId as string) ||
    event.sessionId;

  const ms = typeof payload.ms === 'number' ? Math.max(0, payload.ms) : 0;
  const attempt = typeof payload.attempt === 'number' ? Math.max(1, payload.attempt) : 1;
  const strategyId = (payload.misconceptionId as string) || null;

  return {
    event_id: event.id,
    student_id: authenticatedStudentId,
    session_id: event.sessionId,
    concept_ids: concepts,
    item_id: itemId,
    timestamp: event.at,
    event_type: eventType,
    correctness,
    attempt_number: attempt,
    assistance_level: rung,
    hints_used: hints,
    response_time_ms: ms,
    strategy_id: strategyId,
    assessment_mode: isAssisted ? 'assisted' : 'independent',
    provenance: {
      judgment_source: 'answer_key',
      verifier_version: '1.0',
      verifier_reliability: 'high',
      independently_produced: !isAssisted,
      status: 'verified',
    },
    schema_version: 'v1',
  };
}

/**
 * Translate LAM Recommendation to Qrie Execution Plan.
 */
export function mapLamRecommendationToQrie(
  rec: LamRecommendationPayload,
): QrieExecutionPlan {
  const isFallback = Boolean(rec.safe_fallback);

  let activityType: QrieActivityType = 'standard_practice';
  let rung = rec.assistance_level ?? 0;

  switch (rec.action_type) {
    case 'teacher_intervention':
      activityType = 'teacher_help';
      rung = 8;
      break;
    case 'prerequisite_remediation':
      activityType = 'prerequisite_review';
      rung = 5;
      break;
    case 'diagnostic_probe':
      activityType = 'diagnostic_question';
      rung = 2;
      break;
    case 'delayed_retrieval_review':
      activityType = 'retrieval_challenge';
      rung = 0;
      break;
    case 'mastery_verification':
      activityType = 'mastery_check';
      rung = 0;
      break;
    case 'advance_to_next_concept':
      activityType = 'next_concept';
      rung = 0;
      break;
    case 'worked_example':
      activityType = 'worked_example';
      rung = 5;
      break;
    case 'scaffolded_practice':
      activityType = 'scaffolded_problem';
      rung = 3;
      break;
    case 'independent_practice':
    default:
      activityType = 'standard_practice';
      rung = 0;
      break;
  }

  return {
    activityType,
    assistanceRung: rung,
    targetConceptId: rec.target_concept_id,
    rationale: rec.rationale || 'Instructional activity selected based on learner state.',
    policyVersion: rec.policy_version || 'd06_ladder_v1',
    isSafeFallback: isFallback,
    recommendationId: rec.recommendation_id,
    priorityTier: rec.priority_tier,
    uncertainty: rec.uncertainty ?? undefined,
  };
}

/**
 * Safe fallback plan when LAM is unreachable.
 * STRICT INVARIANT: Never fabricates mastery or BKT parameters.
 */
export function createSafeFallbackPlan(conceptId: string): QrieExecutionPlan {
  return {
    activityType: 'standard_practice',
    assistanceRung: 0,
    targetConceptId: conceptId,
    rationale: 'LAM service unavailable; safe fallback standard practice deployed without mastery estimation.',
    policyVersion: 'safe_fallback_v1',
    isSafeFallback: true,
  };
}

/**
 * Resilient HTTP Transport Client for calling LAM from Qrie's Edge/Server.
 */
export class LamTransportClient {
  private readonly baseUrl: string;
  private readonly secret: string;
  private readonly issuer: string;
  private readonly audience: string;
  private readonly timeoutMs: number;
  private readonly maxRetries: number;
  private readonly fetchImpl: typeof fetch;

  constructor(
    config: LamRelayConfig,
    fetchImpl: typeof fetch = fetch,
  ) {
    this.baseUrl = config.lamBaseUrl.replace(/\/+$/, '');
    this.secret = config.lamSecret;
    this.issuer = config.issuer ?? 'lam-service';
    this.audience = config.audience ?? 'lam-api';
    this.timeoutMs = config.readTimeoutMs ?? 5000;
    this.maxRetries = config.maxRetries ?? 3;
    this.fetchImpl = fetchImpl;
  }

  private async fetchWithRetry(
    url: string,
    options: RequestInit,
  ): Promise<Response> {
    const retryDelays = [200, 500, 1200];

    for (let attempt = 0; attempt <= this.maxRetries; attempt++) {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), this.timeoutMs);

      try {
        const response = await this.fetchImpl(url, {
          ...options,
          signal: controller.signal,
        });
        clearTimeout(timeoutId);

        // Transient server errors: retry
        if ([502, 503, 504].includes(response.status)) {
          if (attempt < this.maxRetries) {
            const baseDelay = retryDelays[attempt] || 1000;
            const jitter = baseDelay * (0.8 + Math.random() * 0.4);
            await new Promise((r) => setTimeout(r, jitter));
            continue;
          }
        }

        return response;
      } catch (err) {
        clearTimeout(timeoutId);
        if (attempt < this.maxRetries) {
          const baseDelay = retryDelays[attempt] || 1000;
          const jitter = baseDelay * (0.8 + Math.random() * 0.4);
          await new Promise((r) => setTimeout(r, jitter));
          continue;
        }
        throw err;
      }
    }

    throw new Error('Retries exhausted');
  }

  /**
   * Forward a verified learning event to LAM POST /v1/events.
   */
  async forwardEvent(
    event: LedgerEvent,
    tenantId: string,
    studentId: string,
  ): Promise<LamIngestResult> {
    const token = await signLamToken(tenantId, studentId, this.secret, {
      issuer: this.issuer,
      audience: this.audience,
    });

    const body = mapLedgerEventToLam(event, studentId);

    const response = await this.fetchWithRetry(`${this.baseUrl}/v1/events`, {
      method: 'POST',
      headers: {
        'content-type': 'application/json',
        authorization: `Bearer ${token}`,
        'x-tenant-id': tenantId,
      },
      body: JSON.stringify(body),
    });

    if (!response.ok) {
      const errText = await response.text().catch(() => '');
      throw new Error(`LAM event ingestion failed with status ${response.status}: ${errText}`);
    }

    const data = (await response.json()) as {
      status: 'ingested' | 'duplicate';
      event_id: string;
      tenant_id: string;
      student_id: string;
      affected_concept_ids: string[];
      ingested_at: string;
      message?: string;
    };

    return {
      status: data.status,
      eventId: data.event_id,
      tenantId: data.tenant_id,
      studentId: data.student_id,
      affectedConceptIds: data.affected_concept_ids,
      ingestedAt: data.ingested_at,
      message: data.message,
    };
  }

  /**
   * Request next-action recommendation from LAM POST /v1/recommendations.
   */
  async getRecommendation(
    tenantId: string,
    studentId: string,
    conceptId: string,
    context: {
      consecutiveFailures?: number;
      activeMisconceptionId?: string | null;
      misconceptionStatus?: string | null;
      prerequisiteReadiness?: boolean;
    } = {},
  ): Promise<QrieExecutionPlan> {
    const token = await signLamToken(tenantId, studentId, this.secret, {
      issuer: this.issuer,
      audience: this.audience,
    });

    const body = {
      student_id: studentId,
      concept_id: conceptId,
      consecutive_failures: context.consecutiveFailures ?? 0,
      active_misconception_id: context.activeMisconceptionId ?? null,
      misconception_status: context.misconceptionStatus ?? null,
      prerequisite_readiness: context.prerequisiteReadiness ?? true,
    };

    try {
      const response = await this.fetchWithRetry(
        `${this.baseUrl}/v1/recommendations`,
        {
          method: 'POST',
          headers: {
            'content-type': 'application/json',
            authorization: `Bearer ${token}`,
            'x-tenant-id': tenantId,
          },
          body: JSON.stringify(body),
        },
      );

      if (!response.ok) {
        // Safe fallback on server error or refusal
        return createSafeFallbackPlan(conceptId);
      }

      const raw = (await response.json()) as LamRecommendationPayload;
      return mapLamRecommendationToQrie(raw);
    } catch {
      // Safe fallback on network failure / retry exhaustion
      return createSafeFallbackPlan(conceptId);
    }
  }
}
