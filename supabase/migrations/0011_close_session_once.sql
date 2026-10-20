-- A GUARD THAT ONLY ENGAGES AFTER THE THING IT GUARDS HAS HAPPENED.
--
-- 0006 closes a sitting through a function rather than an update policy so that
-- `ended_at` and `active_ms` are the only mutable fields and a sitting can be
-- closed exactly once. The once-only half never worked. The guard was
--
--   where id = p_session and user_id = auth.uid() and ended_at is null
--
-- and the statement it guarded was `set ended_at = p_ended_at`. Pass
-- p_ended_at = NULL and the row is written — active_ms and all — while
-- `ended_at` stays null, which is to say the sitting never closes and the guard
-- is never armed. Call it again and it is written again.
--
-- Measured against the deployed project on 2026-09-13, one anonymous student,
-- one sitting, four calls, every one of them HTTP 204:
--
--   p_ended_at=null p_active_ms=92000       -> ended_at=null active_ms=92000
--   p_ended_at=null p_active_ms=36000000    -> ended_at=null active_ms=36000000
--   p_ended_at=null p_active_ms=2147483647  -> ended_at=null active_ms=2147483647
--   p_ended_at=null p_active_ms=null        -> ended_at=null active_ms=null
--
-- That last line is not a curiosity: `active_ms` is the denominator of the
-- primary metric and of cost_per_student_hour, and the moment credits are
-- priced against a learning minute, a student who can write 24 days into it —
-- or erase it — is writing their own bill. The plain second close was the only
-- case the old guard actually caught, and it is the one case nobody would try.
--
-- Two changes, and neither of them is a new check bolted on top:
--
--   1. `ended_at` can no longer be written null. coalesce() to the SERVER clock
--      means the guard's precondition is established by the same statement the
--      guard admits, so a first call always closes the sitting and a second
--      call always finds it closed, whatever it passes. A null p_ended_at is
--      closed at now() rather than refused, because a sitting that cannot be
--      closed at all is a worse failure than one closed at the wrong instant,
--      and now() is the more trustworthy of the two clocks anyway.
--
--   2. A null or negative p_active_ms is refused outright instead of being
--      taken for a number. Coalescing it to 0 would have been the quiet option
--      and it would have written a lie into the denominator; the negative case
--      reached the table's own check constraint and came back as 23514, which
--      tells a caller nothing.
--
-- What deliberately did NOT change: a close of an already-closed sitting is
-- still a silent no-op and NOT an error. The outbox replays batches whose
-- response was lost — replay being free is the property the whole offline drain
-- rests on — and raising here would turn every re-drain into a row held and
-- retried forever.
--
-- Still true and still on the record: nothing bounds active_ms against the wall
-- clock. It cannot be, honestly, from here — `started_at` is the phone's clock
-- and `received_at` is the sync's, so an offline sitting drained an hour later
-- has no server-side elapsed time to be measured against. The first close
-- remains the student's own word. This migration makes it their word ONCE,
-- which is what the function claimed all along. Bounding it needs the timing to
-- come from the relay, and that is the same Phase 2 move as grading answers
-- server-side.

create or replace function public.close_learning_session(
  p_session uuid,
  p_ended_at timestamptz,
  p_active_ms integer
) returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_active_ms is null or p_active_ms < 0 then
    raise exception 'close_learning_session: p_active_ms must be a non-negative count of milliseconds, got %', p_active_ms
      using errcode = '22023';
  end if;

  update public.learning_session
     set ended_at = coalesce(p_ended_at, now()),
         active_ms = p_active_ms
   where id = p_session
     and user_id = auth.uid()
     and ended_at is null;
end;
$$;

-- The grants 0006 wrote, restated because `create or replace` keeps whatever
-- ACL the function already had and an unstated grant is one nobody reviews.
--
-- `anon` is new here, and it is not tidying: measured on the same run, a call
-- carrying only the anon key — nobody signed in — returned 204 rather than
-- permission denied. `revoke ... from public` does not touch the default grant
-- Supabase gives anon on functions created in `public`, so the revoke in 0006
-- read as if it had closed a door that was never shut. It hit no row, because
-- auth.uid() is null and user_id is not, so the damage was zero and the
-- distance from zero was one WHERE clause.
revoke all on function public.close_learning_session(uuid, timestamptz, integer) from public;
revoke all on function public.close_learning_session(uuid, timestamptz, integer) from anon;
grant execute on function public.close_learning_session(uuid, timestamptz, integer) to authenticated;
