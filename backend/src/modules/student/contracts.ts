import { z } from 'zod';
import type { LamEventPayload } from '../lam-integration/client.js';

/**
 * Canonical learning-event contract.
 *
 * The mobile outbox sends a legacy envelope:
 *   { id, event_type: 'learning.answer_submitted', payload, created_at }
 *
 * LAM wants a flat event with a tenant-owned student id, a session, concepts and
 * an item. `normalizeEvent` is the one place that gap is bridged. It is pure, so
 * the eligibility rules can be tested without HTTP, a database or LAM.
 *
 * Provenance rules encoded here:
 *  - `student_id` comes from the verified JWT, never from the request body.
 *  - an event that cannot name a session, a concept or an item is stored but is
 *    NOT relayed; it is marked `skipped` with a machine-readable reason rather
 *    than being allowed to corrupt learner state.
 *  - an attempt with no `correctness` is not evidence either. A missing verdict
 *    is not a wrong answer.
 */

export const LAM_EVENT_TYPES = ['attempt', 'hint', 'explanation', 'assessment', 'review'] as const;
export type LamEventType = (typeof LAM_EVENT_TYPES)[number];

const isoDateTime = z.string().datetime({ offset: true });

export const incomingEventSchema = z.object({
  id: z.string().min(1).max(128),
  event_type: z.string().min(1).max(64),
  payload: z.record(z.any()).optional(),
  created_at: isoDateTime.optional(),

  // Canonical fields may be sent flat instead of nested in `payload`.
  session_id: z.string().min(1).max(128).optional(),
  concept_ids: z.array(z.string().min(1).max(128)).min(1).max(20).optional(),
  item_id: z.string().min(1).max(128).optional(),
  timestamp: isoDateTime.optional(),
  correctness: z.boolean().optional(),
  attempt_number: z.number().int().min(0).max(1000).optional(),
  assistance_level: z.number().int().min(0).max(9).optional(),
  hints_used: z.number().int().min(0).max(100).optional(),
  response_time_ms: z.number().int().min(0).max(86_400_000).optional(),
  difficulty: z.number().min(0).max(1).optional(),
  assessment_mode: z.enum(['independent', 'assisted', 'delayed', 'transfer']).optional(),
});

export type IncomingEvent = z.infer<typeof incomingEventSchema>;

export const incomingEventsSchema = z.object({
  events: z.array(incomingEventSchema).max(20),
});

export type IneligibleReason =
  | 'UNSUPPORTED_EVENT_TYPE'
  | 'MISSING_SESSION_ID'
  | 'MISSING_CONCEPT_IDS'
  | 'MISSING_ITEM_ID'
  | 'MISSING_TIMESTAMP'
  | 'MISSING_CORRECTNESS';

export interface NormalizedEvent {
  eventId: string;
  sessionId: string | null;
  eventType: string;
  occurredAt: string | null;
  payload: Record<string, any>;
  lamEvent: LamEventPayload | null;
  ineligibleReason: IneligibleReason | null;
}

const EVENT_TYPE_ALIASES: Record<string, LamEventType> = {
  'learning.answer_submitted': 'attempt',
  'learning.hint_requested': 'hint',
  'learning.explanation_viewed': 'explanation',
  'learning.assessment_submitted': 'assessment',
  'learning.review_completed': 'review',
};

type LooseObject = Record<string, any>;

function asString(value: unknown): string | undefined {
  return typeof value === 'string' && value.length > 0 ? value : undefined;
}

function asNumber(value: unknown): number | undefined {
  return typeof value === 'number' && Number.isFinite(value) ? value : undefined;
}

function asRung(value: unknown): number | undefined {
  const n = asNumber(value);
  return n !== undefined && Number.isInteger(n) && n >= 0 && n <= 9 ? n : undefined;
}

function isIsoDateTime(value: string | undefined): string | undefined {
  if (!value) return undefined;
  return isoDateTime.safeParse(value).success ? value : undefined;
}

function asObject(value: unknown): LooseObject | undefined {
  return value && typeof value === 'object' && !Array.isArray(value) ? (value as LooseObject) : undefined;
}

export function normalizeEvent(input: IncomingEvent, studentId: string): NormalizedEvent {
  const payload = asObject(input.payload) ?? {};
  const persistedLamEvent = asObject(payload.lamEvent);

  const mappedTypeInput = asString(input.event_type);
  const mappedTypeFromEnvelope = mappedTypeInput && (LAM_EVENT_TYPES as readonly string[]).includes(mappedTypeInput)
    ? (mappedTypeInput as LamEventType)
    : mappedTypeInput
      ? EVENT_TYPE_ALIASES[mappedTypeInput]
      : undefined;
  const mappedTypeFromPersisted = asString(persistedLamEvent?.event_type);
  const mappedType = mappedTypeFromEnvelope ?? (
    mappedTypeFromPersisted && (LAM_EVENT_TYPES as readonly string[]).includes(mappedTypeFromPersisted)
      ? (mappedTypeFromPersisted as LamEventType)
      : undefined
  );

  const sessionId =
    asString(input.session_id) ??
    asString(persistedLamEvent?.session_id) ??
    asString(payload.session_id) ??
    null;

  const conceptIdsFromPersisted = Array.isArray(persistedLamEvent?.concept_ids)
    ? persistedLamEvent!.concept_ids.filter((id: unknown): id is string => typeof id === 'string' && id.length > 0)
    : [];
  const conceptIdsFromPayloadArray = Array.isArray(payload.concept_ids)
    ? payload.concept_ids.filter((id: unknown): id is string => typeof id === 'string' && id.length > 0)
    : [];
  const conceptIdFromPayloadSingle = asString(payload.concept_id);
  const conceptIdFromPersistedSingle = asString(persistedLamEvent?.concept_id);
  const conceptIds = input.concept_ids
    ? input.concept_ids
    : conceptIdsFromPersisted.length > 0
      ? conceptIdsFromPersisted
      : conceptIdsFromPayloadArray.length > 0
        ? conceptIdsFromPayloadArray
        : conceptIdFromPayloadSingle
          ? [conceptIdFromPayloadSingle]
          : conceptIdFromPersistedSingle
            ? [conceptIdFromPersistedSingle]
            : [];

  const itemId =
    asString(input.item_id) ??
    asString(persistedLamEvent?.item_id) ??
    asString(payload.item_id) ??
    asString(payload.question_id) ??
    null;

  const occurredAt =
    isIsoDateTime(asString(input.timestamp)) ??
    isIsoDateTime(asString(persistedLamEvent?.timestamp)) ??
    isIsoDateTime(asString(payload.timestamp)) ??
    isIsoDateTime(asString(input.created_at)) ??
    null;

  const correctness =
    typeof input.correctness === 'boolean'
      ? input.correctness
      : typeof persistedLamEvent?.correctness === 'boolean'
        ? persistedLamEvent.correctness
        : typeof payload.correctness === 'boolean'
          ? payload.correctness
          : typeof payload.is_correct === 'boolean'
            ? payload.is_correct
            : typeof payload.isCorrect === 'boolean'
              ? payload.isCorrect
              : undefined;

  const assistanceLevel =
    asRung(input.assistance_level) ??
    asRung(persistedLamEvent?.assistance_level) ??
    asRung(payload.assistance_level) ??
    asRung(payload.assistance_rung);
  const attemptNumber =
    asNumber(input.attempt_number) ??
    asNumber(persistedLamEvent?.attempt_number) ??
    asNumber(payload.attempt_number);
  const hintsUsed =
    asNumber(input.hints_used) ??
    asNumber(persistedLamEvent?.hints_used) ??
    asNumber(payload.hints_used);
  const responseTimeMs =
    asNumber(input.response_time_ms) ??
    asNumber(persistedLamEvent?.response_time_ms) ??
    asNumber(payload.response_time_ms) ??
    asNumber(payload.duration_ms);
  const difficulty =
    typeof input.difficulty === 'number'
      ? input.difficulty
      : typeof persistedLamEvent?.difficulty === 'number'
        ? persistedLamEvent.difficulty
        : typeof payload.difficulty === 'number'
          ? payload.difficulty
          : undefined;

  const assessmentMode =
    input.assessment_mode ??
    ((asString(persistedLamEvent?.assessment_mode) as LamEventPayload['assessment_mode'] | undefined)) ??
    ((asString(payload.assessment_mode) as LamEventPayload['assessment_mode'] | undefined)) ??
    (mappedType === 'attempt' || mappedType === 'assessment'
      ? assistanceLevel !== undefined && assistanceLevel > 0
        ? 'assisted'
        : 'independent'
      : undefined);

  let ineligibleReason: IneligibleReason | null = null;
  if (!mappedType) ineligibleReason = 'UNSUPPORTED_EVENT_TYPE';
  else if (!sessionId) ineligibleReason = 'MISSING_SESSION_ID';
  else if (conceptIds.length === 0) ineligibleReason = 'MISSING_CONCEPT_IDS';
  else if (!itemId) ineligibleReason = 'MISSING_ITEM_ID';
  else if (!occurredAt) ineligibleReason = 'MISSING_TIMESTAMP';
  else if ((mappedType === 'attempt' || mappedType === 'assessment') && correctness === undefined) {
    ineligibleReason = 'MISSING_CORRECTNESS';
  }

  let lamEvent: LamEventPayload | null = null;
  if (!ineligibleReason) {
    lamEvent = {
      event_id: input.id,
      student_id: studentId,
      session_id: sessionId!,
      concept_ids: conceptIds,
      item_id: itemId!,
      timestamp: occurredAt!,
      event_type: mappedType!,
    };
    if (correctness !== undefined) lamEvent.correctness = correctness;
    if (attemptNumber !== undefined) lamEvent.attempt_number = attemptNumber;
    if (assistanceLevel !== undefined) lamEvent.assistance_level = assistanceLevel;
    if (hintsUsed !== undefined) lamEvent.hints_used = hintsUsed;
    if (responseTimeMs !== undefined) lamEvent.response_time_ms = responseTimeMs;
    if (difficulty !== undefined) lamEvent.difficulty = difficulty;
    if (assessmentMode !== undefined) lamEvent.assessment_mode = assessmentMode;
  }

  return {
    eventId: input.id,
    sessionId,
    eventType: input.event_type,
    occurredAt,
    payload,
    lamEvent,
    ineligibleReason,
  };
}

/**
 * Recommendation contract.
 *
 * `reason_code` is a stable machine string, never prose, and `policy_version`
 * identifies the rule set that produced it. Only the fallback code is known to
 * this repository; LAM owns the rest. `safe_fallback` says whether the
 * recommendation was produced without LAM (true) or by it (false), so a client
 * can avoid presenting a guess as a decision.
 */
export const lamRecommendationSchema = z.object({
  recommendation_id: z.string().min(1).max(128),
  action_type: z.string().min(1).max(64),
  target_concept_id: z.string().min(1).max(128),
  assistance_level: z.number().int().min(0).max(9),
  priority_tier: z.string().min(1).max(64),
  reason_code: z.string().min(1).max(64),
  suggested_strategy: z.string().min(1).max(128),
  rationale: z.string().max(2000),
  policy_version: z.string().min(1).max(64),
  safe_fallback: z.boolean(),
  uncertainty: z.number().min(0).max(1),
});

export type LamRecommendation = z.infer<typeof lamRecommendationSchema>;

export const KNOWN_REASON_CODES = ['LAM_UNREACHABLE_FALLBACK'] as const;
