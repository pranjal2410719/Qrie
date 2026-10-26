import { describe, it, expect, vi, beforeEach } from 'vitest';
import { CircuitBreaker } from '../src/modules/lam-integration/circuit-breaker.js';
import {
  LamAdapterClient,
  getSharedCircuitBreaker,
  resetSharedCircuitBreaker,
} from '../src/modules/lam-integration/client.js';

describe('CircuitBreaker for LAM integration', () => {
  it('starts in CLOSED state and allows successful executions', async () => {
    const cb = new CircuitBreaker({ failureThreshold: 3, resetTimeoutMs: 100 });
    expect(cb.getState()).toBe('CLOSED');

    const result = await cb.execute(
      async () => 'live_response',
      () => 'fallback_response',
    );

    expect(result).toBe('live_response');
    expect(cb.getState()).toBe('CLOSED');
  });

  it('trips to OPEN state after reaching the failure threshold', async () => {
    const cb = new CircuitBreaker({ failureThreshold: 3, resetTimeoutMs: 100 });
    const op = vi.fn().mockRejectedValue(new Error('connection refused'));
    const fallback = vi.fn().mockReturnValue('fallback_response');

    // 1st failure
    await cb.execute(op, fallback);
    expect(cb.getState()).toBe('CLOSED');

    // 2nd failure
    await cb.execute(op, fallback);
    expect(cb.getState()).toBe('CLOSED');

    // 3rd failure -> trips breaker
    await cb.execute(op, fallback);
    expect(cb.getState()).toBe('OPEN');
    expect(op).toHaveBeenCalledTimes(3);

    // 4th call: breaker is OPEN, operation should NOT be invoked
    const result = await cb.execute(op, fallback);
    expect(result).toBe('fallback_response');
    expect(op).toHaveBeenCalledTimes(3); // still 3, network call skipped
  });

  it('transitions to HALF_OPEN after timeout and resets to CLOSED on probe success', async () => {
    const cb = new CircuitBreaker({ failureThreshold: 2, resetTimeoutMs: 50 });
    const failOp = vi.fn().mockRejectedValue(new Error('fail'));
    const fallback = vi.fn().mockReturnValue('fallback');

    await cb.execute(failOp, fallback);
    await cb.execute(failOp, fallback);
    expect(cb.getState()).toBe('OPEN');

    // Wait for reset timeout
    await new Promise((resolve) => setTimeout(resolve, 60));
    expect(cb.getState()).toBe('HALF_OPEN');

    // Probe success
    const successOp = vi.fn().mockResolvedValue('probe_success');
    const result = await cb.execute(successOp, fallback);

    expect(result).toBe('probe_success');
    expect(cb.getState()).toBe('CLOSED');
  });

  it('transitions from HALF_OPEN back to OPEN if probe fails', async () => {
    const cb = new CircuitBreaker({ failureThreshold: 2, resetTimeoutMs: 50 });
    const failOp = vi.fn().mockRejectedValue(new Error('fail'));
    const fallback = vi.fn().mockReturnValue('fallback');

    await cb.execute(failOp, fallback);
    await cb.execute(failOp, fallback);
    expect(cb.getState()).toBe('OPEN');

    // Wait for reset timeout
    await new Promise((resolve) => setTimeout(resolve, 60));
    expect(cb.getState()).toBe('HALF_OPEN');

    // Probe fails
    await cb.execute(failOp, fallback);
    expect(cb.getState()).toBe('OPEN');
  });

  it('resets breaker state and failures with explicit reset() call', () => {
    const cb = new CircuitBreaker({ failureThreshold: 2 });
    cb.recordFailure();
    cb.recordFailure();
    expect(cb.getState()).toBe('OPEN');

    cb.reset();
    expect(cb.getState()).toBe('CLOSED');
    expect(cb.canExecute()).toBe(true);
  });
});

describe('Shared CircuitBreaker across LamAdapterClient instances', () => {
  beforeEach(() => {
    vi.restoreAllMocks();
    resetSharedCircuitBreaker(new CircuitBreaker({ failureThreshold: 3, resetTimeoutMs: 100 }));
  });

  it('accumulates failures across distinct LamAdapterClient instances and trips shared breaker', async () => {
    const fetchSpy = vi.spyOn(globalThis, 'fetch').mockRejectedValue(new Error('connection timeout'));

    // 1st request through instance 1
    const client1 = new LamAdapterClient();
    const rec1 = await client1.getRecommendation('sch_test', { student_id: 'std_1', concept_id: 'c1' });
    expect(rec1.safe_fallback).toBe(true);
    expect(getSharedCircuitBreaker().getState()).toBe('CLOSED');

    // 2nd request through instance 2
    const client2 = new LamAdapterClient();
    const rec2 = await client2.getRecommendation('sch_test', { student_id: 'std_1', concept_id: 'c1' });
    expect(rec2.safe_fallback).toBe(true);
    expect(getSharedCircuitBreaker().getState()).toBe('CLOSED');

    // 3rd request through instance 3 -> hits failureThreshold: 3 and trips
    const client3 = new LamAdapterClient();
    const rec3 = await client3.getRecommendation('sch_test', { student_id: 'std_1', concept_id: 'c1' });
    expect(rec3.safe_fallback).toBe(true);
    expect(getSharedCircuitBreaker().getState()).toBe('OPEN');
    expect(fetchSpy).toHaveBeenCalledTimes(3);

    // 4th request through instance 4: breaker is OPEN, skips network call completely
    const client4 = new LamAdapterClient();
    const rec4 = await client4.getRecommendation('sch_test', { student_id: 'std_1', concept_id: 'c1' });
    expect(rec4.safe_fallback).toBe(true);
    expect(fetchSpy).toHaveBeenCalledTimes(3); // still 3, fast-failed without calling fetch

    // Reset restores normal operation
    resetSharedCircuitBreaker();
    expect(getSharedCircuitBreaker().getState()).toBe('CLOSED');
  });
});
