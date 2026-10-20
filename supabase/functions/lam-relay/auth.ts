/**
 * WHO IS ASKING.
 *
 * Every relay spends money on somebody's behalf — a model call, a voice, a
 * transcription. Until a caller has a name, none of that can be attributed,
 * limited or cut off, and one leaked URL spends until the balance is gone.
 *
 * Verified by ASKING SUPABASE rather than by checking a signature here. That
 * costs one round trip and buys two things worth more than the milliseconds:
 * the project's JWT secret never has to live in this process, and a token
 * revoked at sign-out stops working immediately instead of at its own expiry.
 *
 * This file was written for the LiveKit token server and lives here now
 * because the relays need exactly the same thing. It is fetch-only — no
 * dependencies, no Node built-ins — so the same code runs in the vite dev
 * server, in the Node token server, and inside a Deno Edge Function.
 */

export interface Verified {
  userId: string;
}

export type VerifyResult = { ok: true; user: Verified } | { ok: false; status: number; why: string };

/**
 * The token out of an Authorization header.
 *
 * Pure, and separated because it is the part with edges: a missing header, a
 * scheme that is not Bearer, and the empty string that `"Bearer "` produces
 * are three different failures and all three have been shipped as bugs
 * somewhere.
 */
export function bearerFrom(header: string | undefined): string | null {
  if (!header) return null;
  const match = /^Bearer\s+(\S+)$/i.exec(header.trim());
  return match ? match[1] : null;
}

export interface Verifier {
  (authHeader: string | undefined): Promise<VerifyResult>;
}

/**
 * Build a verifier against one Supabase project.
 *
 * `fetchImpl` is injected so the tests need no network and no project.
 */
export function createSupabaseVerifier(
  supabaseUrl: string,
  anonKey: string,
  fetchImpl: typeof fetch = fetch,
): Verifier {
  return async (authHeader) => {
    const token = bearerFrom(authHeader);
    if (token === null) {
      return { ok: false, status: 401, why: 'expected an Authorization: Bearer <token> header' };
    }

    let res: Response;
    try {
      res = await fetchImpl(`${supabaseUrl}/auth/v1/user`, {
        headers: { apikey: anonKey, authorization: `Bearer ${token}` },
      });
    } catch {
      // The identity provider being unreachable is OUR outage, not the
      // student's fault — but it is still a refusal, because serving an
      // unverified caller is the thing this exists to prevent.
      return { ok: false, status: 503, why: 'could not reach the identity service' };
    }

    if (!res.ok) return { ok: false, status: 401, why: 'that sign-in is not valid' };

    const body = (await res.json().catch(() => null)) as { id?: unknown } | null;
    if (!body || typeof body.id !== 'string' || body.id === '') {
      return { ok: false, status: 401, why: 'that sign-in carries no user' };
    }

    return { ok: true, user: { userId: body.id } };
  };
}

/**
 * Remember an answer for a short while.
 *
 * The LiveKit token server could afford a round trip per call because it
 * mints once per class. `/api/speech` is called once per SPOKEN LINE, and the
 * streaming relay exists to put the first byte on the wire in 0.36 s — a
 * round trip to the identity service before every line would be most of a
 * second of silence between sentences.
 *
 * Thirty seconds is the trade: a revoked session keeps working for at most
 * that long on a relay it was already using, which is a far smaller risk than
 * the alternative of never checking at all. Failures are NOT cached, so an
 * outage does not pin a refusal in place.
 */
export function cacheVerifier(inner: Verifier, ttlMs = 30_000, now: () => number = Date.now): Verifier {
  const seen = new Map<string, { at: number; user: Verified }>();

  return async (authHeader) => {
    const token = bearerFrom(authHeader);
    if (token === null) {
      return { ok: false, status: 401, why: 'expected an Authorization: Bearer <token> header' };
    }

    const hit = seen.get(token);
    if (hit && now() - hit.at < ttlMs) return { ok: true, user: hit.user };

    const result = await inner(authHeader);
    if (result.ok) {
      // Bounded: an Edge Function instance is long-lived and this map would
      // otherwise grow with every token it ever saw.
      if (seen.size > 1000) seen.clear();
      seen.set(token, { at: now(), user: result.user });
    } else {
      seen.delete(token);
    }
    return result;
  };
}
