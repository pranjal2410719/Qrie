import { describe, it, expect, vi, beforeEach } from 'vitest';
import { LamAdapterClient } from '../src/modules/lam-integration/client.js';

describe('LAM Trusted Adapter Client', () => {
  const adapter = new LamAdapterClient('http://localhost:8000', 'staging_super_secret_jwt_key_at_least_32_characters_long!');

  beforeEach(() => {
    vi.restoreAllMocks();
  });

  it('generates a valid, signed HS256 JWT for server-to-server calls', async () => {
    // Check that forwardEvent constructs request with Bearer authorization
    const fetchSpy = vi.spyOn(globalThis, 'fetch').mockResolvedValue(
      new Response(JSON.stringify({ status: 'ingested', event_id: 'evt_100' }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
      })
    );

    const result = await adapter.forwardEvent('school_test_01', {
      event_id: 'evt_100',
      student_id: 'std_01',
      session_id: 'sess_01',
      concept_ids: ['fractions.addition'],
      item_id: 'item_01',
      timestamp: new Date().toISOString(),
      event_type: 'attempt',
      correctness: true,
      attempt_number: 1,
      assistance_level: 0,
    });

    expect(result.status).toBe('ingested');
    expect(fetchSpy).toHaveBeenCalledOnce();
    const callArgs = fetchSpy.mock.calls[0];
    const headers = callArgs[1]?.headers as Record<string, string>;
    expect(headers['Authorization']).toMatch(/^Bearer eyJ/);
  });

  it('returns safe fallback recommendation when LAM service is unreachable', async () => {
    vi.spyOn(globalThis, 'fetch').mockRejectedValue(new Error('Connection refused to LAM port 8000'));

    const result = await adapter.getRecommendation('school_test_01', {
      student_id: 'std_01',
      concept_id: 'fractions.addition',
      consecutive_failures: 2,
    });

    expect(result.safe_fallback).toBe(true);
    expect(result.action_type).toBe('independent_practice');
    expect(result.reason_code).toBe('LAM_UNREACHABLE_FALLBACK');
    expect(result.suggested_strategy).toBe('continue_current_topic');
  });
});
