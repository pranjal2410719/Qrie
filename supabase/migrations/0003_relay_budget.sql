-- A LOCK AND A METER ON THE RELAYS.
--
-- Every relay spends money: a model call, a voice, a transcription. Until now
-- the URLs were open — one of them in a browser's network tab is a free model
-- endpoint for whoever finds it, and there is no alarm at the bottom of the
-- balance. The first sign would be a class that will not prepare.
--
-- Two limits, because they stop different things:
--
--   * requests per minute stops a loop — a retry that never gives up, a script
--     hammering the URL — and it stops it in seconds.
--   * units per day stops patience. Somebody with a valid account and no
--     hurry cannot spend a month of runway overnight.
--
-- The numbers live in packages/relay/src/gate.ts as well, because the dev
-- server counts in memory against the same limits. They are duplicated on
-- purpose and both sides say so: a single source would have to be read at
-- runtime by a database function, which is a worse trade than two constants
-- with a comment pointing at each other.

create table if not exists public.relay_usage (
  user_id uuid primary key references auth.users on delete cascade,
  -- The day the units below belong to, in UTC. Compared rather than swept:
  -- there is no cron here, and a row whose day is not today is simply read as
  -- a fresh one. That also means a student who does not come back leaves one
  -- stale row rather than needing to be cleaned up.
  day date not null,
  day_units integer not null default 0,
  -- The current fixed one-minute window. Fixed rather than sliding: a sliding
  -- window needs a row per request, and this is a ceiling, not an accounting
  -- system.
  window_start timestamptz not null,
  window_count integer not null default 0
);

alter table public.relay_usage enable row level security;

-- No policy is granted to anybody. That is deliberate and is not an omission:
-- the only thing that touches this table is claim_relay below, which runs as
-- its definer. A student has no reason to read their own meter and every
-- reason not to be able to write it.

-- Kept in step with REQUESTS_PER_MINUTE and UNITS_PER_DAY in
-- packages/relay/src/gate.ts.
create or replace function public.claim_relay(
  p_user uuid,
  p_relay text,
  p_units integer
)
returns table (allowed boolean, reason text, retry_after integer)
language plpgsql
security definer
set search_path = public
as $$
declare
  requests_per_minute constant integer := 120;
  units_per_day constant integer := 3000;
  now_at timestamptz := now();
  today date := (now_at at time zone 'utc')::date;
  row_units integer;
  row_window_start timestamptz;
  row_window_count integer;
begin
  if p_user is null or p_units is null or p_units < 0 then
    raise exception 'claim_relay needs a user and a non-negative cost';
  end if;

  -- One statement, so two calls from two Edge Function instances cannot both
  -- read 119 and both write 120. The row is locked by the update itself.
  insert into public.relay_usage as u (user_id, day, day_units, window_start, window_count)
  values (p_user, today, 0, date_trunc('minute', now_at), 0)
  on conflict (user_id) do update
    set
      -- A new day resets the budget; a new minute resets the window. Both are
      -- decided here rather than by a sweep, so nothing has to run on a timer.
      day = today,
      day_units = case when u.day = today then u.day_units else 0 end,
      window_start = case
        when now_at - u.window_start >= interval '1 minute' then date_trunc('minute', now_at)
        else u.window_start
      end,
      window_count = case
        when now_at - u.window_start >= interval '1 minute' then 0
        else u.window_count
      end
  returning u.day_units, u.window_start, u.window_count
  into row_units, row_window_start, row_window_count;

  if row_window_count >= requests_per_minute then
    return query select
      false,
      'rate'::text,
      greatest(1, ceil(extract(epoch from (row_window_start + interval '1 minute' - now_at)))::integer);
    return;
  end if;

  if row_units + p_units > units_per_day then
    -- Midnight UTC, which is when `today` above rolls over. Written as
    -- "at time zone 'utc'" rather than a plain cast: a bare ::timestamptz
    -- reads the date in the SESSION's zone, so on a database that is not set
    -- to UTC this came out negative and clamped to a one-second wait — a
    -- Retry-After that told a client to come straight back to the same refusal.
    return query select
      false,
      'budget'::text,
      greatest(
        1,
        ceil(extract(epoch from (((today + 1)::timestamp at time zone 'utc') - now_at)))::integer
      );
    return;
  end if;

  update public.relay_usage
     set day_units = day_units + p_units,
         window_count = window_count + 1
   where user_id = p_user;

  return query select true, null::text, 0;
end;
$$;

-- ONLY THE SERVER MAY METER.
--
-- The Edge Function calls this with the service role key and a user id it has
-- already established — from a verified Authorization header, or from a
-- signed speech ticket. It is never taken from the request body. Granting it
-- to `authenticated` would let a student meter somebody else, or quietly not
-- meter themselves.
revoke all on function public.claim_relay(uuid, text, integer) from public;
revoke all on function public.claim_relay(uuid, text, integer) from anon;
revoke all on function public.claim_relay(uuid, text, integer) from authenticated;
grant execute on function public.claim_relay(uuid, text, integer) to service_role;
