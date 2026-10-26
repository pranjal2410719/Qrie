import { describe, it, expect, vi } from 'vitest';
import { CircuitBreaker } from '../src/modules/lam-integration/circuit-breaker.js';

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
});
