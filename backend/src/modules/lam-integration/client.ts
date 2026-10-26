import crypto from 'crypto';
import { config } from '../../config/index.js';
import { CircuitBreaker, CircuitState } from './circuit-breaker.js';

export interface LamEventPayload {
  event_id: string;
  student_id: string;
  session_id: string;
  concept_ids: string[];
  item_id: string;
  timestamp: string;
  event_type: 'attempt' | 'hint' | 'explanation' | 'assessment' | 'review';
  correctness?: boolean;
  attempt_number?: number;
  assistance_level?: number;
  hints_used?: number;
  response_time_ms?: number;
  difficulty?: number;
  assessment_mode?: 'independent' | 'assisted' | 'delayed' | 'transfer';
}

export interface LamRecommendationRequest {
  student_id: string;
  concept_id: string;
  consecutive_failures?: number;
}

export interface LamRecommendationResponse {
  recommendation_id: string;
  action_type: string;
  target_concept_id: string;
  assistance_level: number;
  priority_tier: string;
  reason_code: string;
  suggested_strategy: string;
  rationale: string;
  policy_version: string;
  safe_fallback: boolean;
  uncertainty: number;
}

/**
 * Shared CircuitBreaker instance for the application process.
 * Ensures failure accumulation across distinct HTTP requests so the circuit
 * breaker trips globally when the upstream LAM service is degraded.
 */
let sharedCircuitBreaker = new CircuitBreaker({
  failureThreshold: 5,
  resetTimeoutMs: 15000,
  halfOpenMaxCalls: 2,
});

export function getSharedCircuitBreaker(): CircuitBreaker {
  return sharedCircuitBreaker;
}

export function resetSharedCircuitBreaker(newBreaker?: CircuitBreaker): void {
  if (newBreaker) {
    sharedCircuitBreaker = newBreaker;
  } else {
    sharedCircuitBreaker.reset();
  }
}

export class LamAdapterClient {
  private baseUrl: string;
  private secret: string;
  private timeoutMs: number;
  private circuitBreaker: CircuitBreaker;

  constructor(
    baseUrl?: string,
    secret?: string,
    timeoutMs?: number,
    circuitBreaker?: CircuitBreaker,
  ) {
    this.baseUrl = baseUrl || config.LAM_BASE_URL;
    this.secret = secret || config.LAM_JWT_SECRET;
    this.timeoutMs = timeoutMs ?? config.LAM_TIMEOUT_MS;
    this.circuitBreaker = circuitBreaker ?? sharedCircuitBreaker;
  }

  public getCircuitState(): CircuitState {
    return this.circuitBreaker.getState();
  }

  /**
   * Generates a signed JWT in memory for server-to-server communication with LAM.
   */
  private generateLamToken(tenantId: string): string {
    const header = Buffer.from(JSON.stringify({ alg: 'HS256', typ: 'JWT' })).toString('base64url');
    const now = Math.floor(Date.now() / 1000);
    const payload = Buffer.from(
      JSON.stringify({
        sub: `qrie-relay-${tenantId}`,
        tenant_id: tenantId,
        school_id: tenantId,
        roles: ['service'],
        iss: 'lam-auth',
        aud: 'lam-service',
        iat: now,
        exp: now + 3600,
      })
    ).toString('base64url');

    const signature = crypto
      .createHmac('sha256', this.secret)
      .update(`${header}.${payload}`)
      .digest('base64url');

    return `${header}.${payload}.${signature}`;
  }

  /**
   * Forwards a verified learning interaction event to LAM's append-only ledger.
   */
  public async forwardEvent(tenantId: string, event: LamEventPayload): Promise<{ status: string; event_id: string }> {
    const token = this.generateLamToken(tenantId);
    try {
      const response = await fetch(`${this.baseUrl}/v1/events`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(event),
        signal: AbortSignal.timeout(this.timeoutMs),
      });

      if (!response.ok) {
        throw new Error(`LAM returned HTTP ${response.status}: ${await response.text()}`);
      }

      return (await response.json()) as { status: string; event_id: string };
    } catch (err: any) {
      console.warn(`[LAM Adapter] Event forwarding failed (${err.message}). Queuing for retry.`);
      return { status: 'relay_queued', event_id: event.event_id };
    }
  }

  /**
   * Queries LAM for the next adaptive pedagogical activity.
   * Returns deterministic fallback if LAM is unreachable or if circuit breaker is OPEN.
   */
  public async getRecommendation(
    tenantId: string,
    req: LamRecommendationRequest
  ): Promise<LamRecommendationResponse> {
    return this.circuitBreaker.execute(
      async () => {
        const token = this.generateLamToken(tenantId);
        const response = await fetch(`${this.baseUrl}/v1/recommendations`, {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${token}`,
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(req),
          signal: AbortSignal.timeout(this.timeoutMs),
        });

        if (!response.ok) {
          throw new Error(`LAM returned HTTP ${response.status}`);
        }

        return (await response.json()) as LamRecommendationResponse;
      },
      (err: Error) => {
        console.warn(`[LAM Adapter] Recommendation retrieval failed (${err.message}). Returning safe fallback.`);
        return {
          recommendation_id: `fallback_${Date.now()}`,
          action_type: 'independent_practice',
          target_concept_id: req.concept_id,
          assistance_level: 0,
          priority_tier: 'tier_safe_fallback',
          reason_code: 'LAM_UNREACHABLE_FALLBACK',
          suggested_strategy: 'continue_current_topic',
          rationale: 'Deterministic fallback engaged while LAM service is recovering.',
          policy_version: 'fallback-v1',
          safe_fallback: true,
          uncertainty: 0.5,
        };
      },
    );
  }
}
