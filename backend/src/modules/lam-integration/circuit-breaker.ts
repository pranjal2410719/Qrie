export type CircuitState = 'CLOSED' | 'OPEN' | 'HALF_OPEN';

export interface CircuitBreakerOptions {
  failureThreshold?: number; // Consecutive failures to trip breaker (default: 5)
  resetTimeoutMs?: number;   // Duration in ms before transitioning from OPEN to HALF_OPEN (default: 15000)
  halfOpenMaxCalls?: number; // Number of test requests allowed in HALF_OPEN (default: 2)
}

export class CircuitBreaker {
  private state: CircuitState = 'CLOSED';
  private failureCount: number = 0;
  private lastFailureTime: number = 0;
  private halfOpenCalls: number = 0;
  private readonly failureThreshold: number;
  private readonly resetTimeoutMs: number;
  private readonly halfOpenMaxCalls: number;

  constructor(options: CircuitBreakerOptions = {}) {
    this.failureThreshold = options.failureThreshold ?? 5;
    this.resetTimeoutMs = options.resetTimeoutMs ?? 15000;
    this.halfOpenMaxCalls = options.halfOpenMaxCalls ?? 2;
  }

  public getState(): CircuitState {
    if (this.state === 'OPEN' && Date.now() - this.lastFailureTime > this.resetTimeoutMs) {
      this.state = 'HALF_OPEN';
      this.halfOpenCalls = 0;
    }
    return this.state;
  }

  public canExecute(): boolean {
    const currentState = this.getState();
    if (currentState === 'CLOSED') return true;
    if (currentState === 'HALF_OPEN') {
      return this.halfOpenCalls < this.halfOpenMaxCalls;
    }
    return false; // OPEN
  }

  public recordSuccess(): void {
    this.failureCount = 0;
    this.state = 'CLOSED';
    this.halfOpenCalls = 0;
  }

  public recordFailure(): void {
    this.failureCount += 1;
    this.lastFailureTime = Date.now();
    if (this.state === 'HALF_OPEN' || this.failureCount >= this.failureThreshold) {
      this.state = 'OPEN';
    }
  }

  public async execute<T>(
    operation: () => Promise<T>,
    fallback: (err: Error) => Promise<T> | T,
  ): Promise<T> {
    if (!this.canExecute()) {
      return fallback(new Error('Circuit breaker is OPEN; skipping remote network call'));
    }

    if (this.state === 'HALF_OPEN') {
      this.halfOpenCalls += 1;
    }

    try {
      const result = await operation();
      this.recordSuccess();
      return result;
    } catch (err: any) {
      this.recordFailure();
      return fallback(err);
    }
  }
}
