import { describe, it, expect } from 'vitest';
import {
  KNOWN_REASON_CODES,
  lamRecommendationSchema,
  normalizeEvent,
} from '../src/modules/student/contracts.js';

describe('Learning event contract', () => {
  it('maps a canonical attempt to a LAM event', () => {
    const event = normalizeEvent(
      {
        id: 'evt_1',
        event_type: 'attempt',
        session_id: 'sess_1',
        concept_ids: ['fractions.addition'],
        item_id: 'item_1',
        timestamp: '2026-10-23T10:00:00.000Z',
        correctness: true,
        assistance_level: 0,
        attempt_number: 1,
      },
      'std_1',
    );

    expect(event.ineligibleReason).toBeNull();
    expect(event.lamEvent).toEqual({
      event_id: 'evt_1',
      student_id: 'std_1',
      session_id: 'sess_1',
      concept_ids: ['fractions.addition'],
      item_id: 'item_1',
      timestamp: '2026-10-23T10:00:00.000Z',
      event_type: 'attempt',
      correctness: true,
      attempt_number: 1,
      assistance_level: 0,
      assessment_mode: 'independent',
    });
  });

  it('maps the mobile outbox envelope when it carries session and concept', () => {
    const event = normalizeEvent(
      {
        id: 'evt_2',
        event_type: 'learning.answer_submitted',
        created_at: '2026-10-23T10:05:00.000Z',
        payload: {
          question_id: 'q4',
          concept_id: 'pressure',
          session_id: 'sess_9',
          is_correct: false,
          assistance_rung: 2,
          duration_ms: 4200,
        },
      },
      'std_1',
    );

    expect(event.lamEvent).toMatchObject({
      event_type: 'attempt',
      student_id: 'std_1',
      session_id: 'sess_9',
      concept_ids: ['pressure'],
      item_id: 'q4',
      correctness: false,
      assistance_level: 2,
      response_time_ms: 4200,
      assessment_mode: 'assisted',
    });
  });

  it('derives student_id from the caller, never from the payload', () => {
    const event = normalizeEvent(
      {
        id: 'evt_3',
        event_type: 'attempt',
        session_id: 'sess_1',
        concept_ids: ['c1'],
        item_id: 'i1',
        timestamp: '2026-10-23T10:00:00.000Z',
        correctness: true,
        payload: { student_id: 'someone_else' },
      },
      'std_verified',
    );

    expect(event.lamEvent?.student_id).toBe('std_verified');
  });

  it('refuses to relay an attempt with no session', () => {
    const event = normalizeEvent(
      {
        id: 'evt_4',
        event_type: 'learning.answer_submitted',
        created_at: '2026-10-23T10:00:00.000Z',
        payload: { question_id: 'q4', concept_ids: ['c1'], is_correct: true },
      },
      'std_1',
    );

    expect(event.lamEvent).toBeNull();
    expect(event.ineligibleReason).toBe('MISSING_SESSION_ID');
  });

  it('refuses to relay an event with no concept', () => {
    const event = normalizeEvent(
      {
        id: 'evt_5',
        event_type: 'attempt',
        session_id: 'sess_1',
        item_id: 'i1',
        timestamp: '2026-10-23T10:00:00.000Z',
        correctness: true,
      },
      'std_1',
    );

    expect(event.ineligibleReason).toBe('MISSING_CONCEPT_IDS');
  });

  it('refuses to treat a missing verdict as a wrong answer', () => {
    const event = normalizeEvent(
      {
        id: 'evt_6',
        event_type: 'attempt',
        session_id: 'sess_1',
        concept_ids: ['c1'],
        item_id: 'i1',
        timestamp: '2026-10-23T10:00:00.000Z',
      },
      'std_1',
    );

    expect(event.lamEvent).toBeNull();
    expect(event.ineligibleReason).toBe('MISSING_CORRECTNESS');
  });

  it('accepts persisted outbox payload.lamEvent correctness from relay flow', () => {
    const event = normalizeEvent(
      {
        id: 'evt_persisted_1',
        event_type: 'learning.answer_submitted',
        session_id: 'sess_1',
        created_at: '2026-10-23T10:00:00.000Z',
        payload: {
          lamEvent: {
            event_type: 'attempt',
            session_id: 'sess_1',
            concept_ids: ['c1'],
            item_id: 'i1',
            timestamp: '2026-10-23T10:00:00.000Z',
            correctness: true,
            assistance_level: 0,
            attempt_number: 1,
          },
        },
      },
      'std_1',
    );

    expect(event.ineligibleReason).toBeNull();
    expect(event.lamEvent).toMatchObject({
      event_id: 'evt_persisted_1',
      student_id: 'std_1',
      event_type: 'attempt',
      correctness: true,
    });
  });

  it('maps persisted camelCase correctness to avoid false MISSING_CORRECTNESS', () => {
    const event = normalizeEvent(
      {
        id: 'evt_persisted_2',
        event_type: 'attempt',
        session_id: 'sess_1',
        concept_ids: ['c1'],
        item_id: 'i1',
        timestamp: '2026-10-23T10:00:00.000Z',
        payload: { isCorrect: false },
      },
      'std_1',
    );

    expect(event.ineligibleReason).toBeNull();
    expect(event.lamEvent?.correctness).toBe(false);
  });

  it('does not forward invalid optional metadata from persisted JSON', () => {
    const event = normalizeEvent(
      {
        id: 'evt_invalid_persisted_metadata',
        event_type: 'attempt',
        session_id: 'sess_1',
        concept_ids: ['c1'],
        item_id: 'i1',
        timestamp: '2026-10-23T10:00:00.000Z',
        correctness: true,
        payload: {
          attempt_number: -1,
          hints_used: 101,
          response_time_ms: -5,
          difficulty: 1.5,
          assessment_mode: 'invented-mode',
          lamEvent: {
            attempt_number: 1.5,
            hints_used: -1,
            response_time_ms: 86_400_001,
            difficulty: -0.1,
            assessment_mode: 'not-a-real-mode',
          },
        },
      },
      'std_1',
    );

    expect(event.lamEvent).toMatchObject({
      event_type: 'attempt',
      correctness: true,
    });
    expect(event.lamEvent?.assessment_mode).toBeUndefined();
    expect(event.lamEvent?.attempt_number).toBeUndefined();
    expect(event.lamEvent?.hints_used).toBeUndefined();
    expect(event.lamEvent?.response_time_ms).toBeUndefined();
    expect(event.lamEvent?.difficulty).toBeUndefined();
  });

  it('derives a safe assessment mode when persisted mode is invalid', () => {
    const event = normalizeEvent(
      {
        id: 'evt_invalid_mode_with_assistance',
        event_type: 'attempt',
        session_id: 'sess_1',
        concept_ids: ['c1'],
        item_id: 'i1',
        timestamp: '2026-10-23T10:00:00.000Z',
        correctness: true,
        payload: {
          assistance_level: 2,
          assessment_mode: 'unknown-mode',
          lamEvent: { assessment_mode: 'unknown-mode' },
        },
      },
      'std_1',
    );

    expect(event.ineligibleReason).toBeNull();
    expect(event.lamEvent?.assistance_level).toBe(2);
    expect(event.lamEvent?.assessment_mode).toBe('assisted');
  });

  it('allows a hint event without a correctness verdict', () => {
    const event = normalizeEvent(
      {
        id: 'evt_7',
        event_type: 'hint',
        session_id: 'sess_1',
        concept_ids: ['c1'],
        item_id: 'i1',
        timestamp: '2026-10-23T10:00:00.000Z',
        hints_used: 1,
      },
      'std_1',
    );

    expect(event.ineligibleReason).toBeNull();
    expect(event.lamEvent?.event_type).toBe('hint');
    expect(event.lamEvent?.hints_used).toBe(1);
  });

  it('labels an unknown event type instead of guessing', () => {
    const event = normalizeEvent(
      {
        id: 'evt_8',
        event_type: 'learning.something_new',
        session_id: 'sess_1',
        concept_ids: ['c1'],
        item_id: 'i1',
        timestamp: '2026-10-23T10:00:00.000Z',
      },
      'std_1',
    );

    expect(event.ineligibleReason).toBe('UNSUPPORTED_EVENT_TYPE');
  });

  it('ignores an out-of-range assistance rung rather than sending it', () => {
    const event = normalizeEvent(
      {
        id: 'evt_9',
        event_type: 'attempt',
        session_id: 'sess_1',
        concept_ids: ['c1'],
        item_id: 'i1',
        timestamp: '2026-10-23T10:00:00.000Z',
        correctness: false,
        assistance_level: 12,
      },
      'std_1',
    );

    expect(event.lamEvent?.assistance_level).toBeUndefined();
    expect(event.lamEvent?.assessment_mode).toBeUndefined();
  });

  it('does not infer independent assessment mode when assistance level is missing', () => {
    const event = normalizeEvent(
      {
        id: 'evt_missing_assistance',
        event_type: 'attempt',
        session_id: 'sess_1',
        concept_ids: ['c1'],
        item_id: 'i1',
        timestamp: '2026-10-23T10:00:00.000Z',
        correctness: true,
      },
      'std_1',
    );

    expect(event.lamEvent).not.toBeNull();
    expect(event.lamEvent?.assistance_level).toBeUndefined();
    expect(event.lamEvent?.assessment_mode).toBeUndefined();
  });

  it('rejects an unparseable timestamp', () => {
    const event = normalizeEvent(
      {
        id: 'evt_10',
        event_type: 'attempt',
        session_id: 'sess_1',
        concept_ids: ['c1'],
        item_id: 'i1',
        created_at: 'yesterday-ish',
        correctness: true,
      },
      'std_1',
    );

    expect(event.ineligibleReason).toBe('MISSING_TIMESTAMP');
  });
});

describe('Recommendation contract', () => {
  it('validates the deterministic fallback produced when LAM is unreachable', () => {
    const fallback = {
      recommendation_id: 'fallback_1',
      action_type: 'independent_practice',
      target_concept_id: 'c1',
      assistance_level: 0,
      priority_tier: 'tier_safe_fallback',
      reason_code: KNOWN_REASON_CODES[0],
      suggested_strategy: 'continue_current_topic',
      rationale: 'Deterministic fallback engaged while LAM service is recovering.',
      policy_version: 'fallback-v1',
      safe_fallback: true,
      uncertainty: 0.5,
    };

    expect(lamRecommendationSchema.parse(fallback)).toMatchObject({ safe_fallback: true });
  });

  it('rejects a recommendation outside the bounded assistance ladder', () => {
    const result = lamRecommendationSchema.safeParse({
      recommendation_id: 'r1',
      action_type: 'hint',
      target_concept_id: 'c1',
      assistance_level: 12,
      priority_tier: 'tier_1',
      reason_code: 'SOME_CODE',
      suggested_strategy: 'socratic',
      rationale: '',
      policy_version: 'policy-v1',
      safe_fallback: false,
      uncertainty: 0.2,
    });

    expect(result.success).toBe(false);
  });
});
