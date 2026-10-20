-- KEEPING A CHILD'S ANSWERS ONLY AS LONG AS THEY ARE USEFUL.
--
-- The ledger holds answer text written by minors. Two obligations follow, and
-- neither is satisfied by good intentions in a docstring:
--
--   * ERASURE. When an account goes, everything about that student goes with
--     it. Most of this already worked — ledger_event and learning_session both
--     cascade from auth.users — but the solo organization created for that
--     student by the 0005 trigger referenced nothing that cascades, so deleting
--     an account left an orphaned row behind forever. Small, and exactly the
--     kind of small that is embarrassing to explain later.
--   * RETENTION. Raw events are worth a great deal for weeks and very little
--     after that: the learner model has already absorbed them, and what remains
--     is a log of a child's schooling. A record with no end date is not a
--     retention policy.
--
-- Retention is enforced by a function rather than a policy because Postgres has
-- no "delete yourself after N days". Something has to call it. The keepalive
-- workflow already runs on a schedule and already holds credentials, which
-- makes it the honest place — an unscheduled purge function is a promise with
-- nobody keeping it, and that should be visible rather than assumed.

-- ---------------------------------------------------------------------------
-- Erasure: take the empty organization with the last member who left it.
-- ---------------------------------------------------------------------------
create or replace function public.drop_empty_solo_org()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  -- Only a solo org, and only once nobody is left in it. A school with no
  -- members is a school between terms, not rubbish.
  delete from public.organization o
   where o.id = old.org_id
     and o.kind = 'solo'
     and not exists (select 1 from public.membership m where m.org_id = o.id);
  return old;
end;
$$;

drop trigger if exists on_membership_removed on public.membership;
create trigger on_membership_removed
  after delete on public.membership
  for each row execute function public.drop_empty_solo_org();

-- Clean up the ones already orphaned by deletions that happened before this.
delete from public.organization o
 where o.kind = 'solo'
   and not exists (select 1 from public.membership m where m.org_id = o.id);

-- ---------------------------------------------------------------------------
-- Retention.
-- ---------------------------------------------------------------------------

/**
 * Ninety days.
 *
 * Long enough to cover a school term, so the learning scientist can still see a
 * whole arc of a student's work and a misconception that reappears after six
 * weeks is still visible as a repeat. Short enough that this is a working set
 * rather than a childhood.
 */
create or replace function public.purge_old_ledger(p_days integer default 90)
returns table (events_deleted bigint, sessions_deleted bigint)
language plpgsql
security definer
set search_path = public
as $$
declare
  cutoff timestamptz := now() - make_interval(days => greatest(p_days, 1));
  ev bigint;
  se bigint;
begin
  -- RECEIVED_AT, not `at`. `at` is the device's clock and a phone set to 2019
  -- would have its events purged the moment they arrived; `received_at` is
  -- Postgres's own and is the only clock that can be trusted to age a row.
  delete from public.ledger_event where received_at < cutoff;
  get diagnostics ev = row_count;

  -- A session is only removed once nothing references it, so a long class that
  -- straddles the cutoff never loses its opening while keeping its end.
  delete from public.learning_session s
   where s.received_at < cutoff
     and not exists (select 1 from public.ledger_event e where e.session_id = s.id);
  get diagnostics se = row_count;

  return query select ev, se;
end;
$$;

-- The purge is an operator's tool, never a student's: a function a browser
-- could call is a function a browser could call with p_days = 1.
revoke all on function public.purge_old_ledger(integer) from public;
revoke all on function public.purge_old_ledger(integer) from anon;
revoke all on function public.purge_old_ledger(integer) from authenticated;
grant execute on function public.purge_old_ledger(integer) to service_role;

-- Ageing is the purge's only access pattern, and it is a full-table scan
-- without this once the table is large.
create index if not exists ledger_event_received on public.ledger_event (received_at);
create index if not exists learning_session_received on public.learning_session (received_at);
