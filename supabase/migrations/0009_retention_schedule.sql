-- ---------------------------------------------------------------------------
-- THE RETENTION WINDOW, ACTUALLY RUNNING.
--
-- 0007 wrote `purge_old_ledger`, locked it to service_role, indexed the column
-- it scans, and documented ninety days as the window. Everything about it was
-- right except that NOTHING EVER CALLED IT. The plan recorded retention as
-- shipped; the database has been keeping every answer since the first one.
--
-- That is not a tidy-up. This table holds answer text written by children, and
-- a retention window that exists only in a comment is the kind of claim that is
-- worse than making no claim at all.
--
-- It is scheduled INSIDE Postgres rather than from a runner, and that choice is
-- the point. The alternative is a service_role key sitting in a scheduler
-- somewhere — a key that can read and delete every student's record, held by a
-- third party, to run one statement a day. pg_cron runs in the database, so the
-- key never exists. The keepalive ping stays outside because it must prove the
-- database is reachable from the internet; this must not leave it.
-- ---------------------------------------------------------------------------

create extension if not exists pg_cron;

-- Unschedule first so this migration is safe to run twice, and so changing the
-- hour later is an edit to this file rather than a second job racing the first.
do $$
begin
  perform cron.unschedule('purge-old-ledger');
exception
  when others then null; -- no such job yet, which is the ordinary first run
end;
$$;

/**
 * 19:30 UTC daily — 01:00 in India, which is the quietest hour for this
 * audience and nowhere near a school day. A delete that scans by `received_at`
 * is cheap on an indexed column, but it is still a delete, and it should not be
 * competing with a class.
 */
select cron.schedule(
  'purge-old-ledger',
  '30 19 * * *',
  $job$ select public.purge_old_ledger(90); $job$
);

-- The job runs as the role that created it, which is the migration role, not
-- `authenticated` — so the grant in 0007 is untouched and a browser still
-- cannot reach the function.
