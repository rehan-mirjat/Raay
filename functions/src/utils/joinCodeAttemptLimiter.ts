export interface AttemptLimiterState {
  windowStart?: number;
  attempts?: number;
  lockedUntil?: number;
}

export interface AttemptLimiterResult {
  allowed: boolean;
  nextState: AttemptLimiterState;
  retryAfterMs?: number;
}

/**
 * Table 3-4: "5 failed attempts per user per 10 minutes, then a 15-minute
 * lockout" - two distinct phases, not one reused window. Pure function so the
 * exact boundary behaviour is unit-testable without the Firestore emulator;
 * callers persist `nextState` transactionally and throw based on `allowed`.
 */
export function checkJoinCodeAttempt(
  now: number,
  state: AttemptLimiterState,
  accrualWindowMs = 10 * 60 * 1000,
  lockoutMs = 15 * 60 * 1000,
  maxAttempts = 5
): AttemptLimiterResult {
  const lockedUntil = state.lockedUntil || 0;
  if (now < lockedUntil) {
    return { allowed: false, nextState: state, retryAfterMs: lockedUntil - now };
  }

  let windowStart = state.windowStart || now;
  let attempts = state.attempts || 0;

  if (now - windowStart >= accrualWindowMs) {
    windowStart = now;
    attempts = 0;
  }

  attempts += 1;

  if (attempts > maxAttempts) {
    return { allowed: false, nextState: { windowStart, attempts, lockedUntil: now + lockoutMs }, retryAfterMs: lockoutMs };
  }

  return { allowed: true, nextState: { windowStart, attempts } };
}
