-- THE METER WAS CHARGING MOST FOR THE CHEAPEST THING.
--
-- 0003 set units_per_day to 3000 against a price table that was the inverse
-- of the bill: a speech call cost one unit however long the text, while a
-- judge call costing fourteen paise cost ten. The per-relay prices live in
-- packages/relay/src/gate.ts and arrive here as p_units, so they need no
-- migration — but the DAY'S BUDGET lives in both places, and if only the code
-- moves, every student is refused inside their first class.
--
-- One unit is now one paisa of vendor spend, and 12,000 of them is seven
-- classes a day. What a class weighs is deliberately NOT restated here: it was
-- copied into this header once and drifted four units out within a day, which
-- is how a comment starts lying. The weights, the measured class they came
-- from and the arithmetic are in the docblock on UNITS_PER_DAY in gate.ts, and
-- packages/relay/tests/gate.test.ts asserts them. What this file must keep in
-- step with the code is the CEILING below, and only that.
--
-- Only the two constants change. Everything else — the atomic single-
-- statement claim, the UTC midnight Retry-After, the service_role-only grant
-- — is 0003's, restated because create or replace takes the whole body.

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
  units_per_day constant integer := 12000;
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

-- create or replace keeps the grants, but restated so a reader of this file
-- alone cannot conclude the function is open to anybody signed in.
revoke all on function public.claim_relay(uuid, text, integer) from public;
revoke all on function public.claim_relay(uuid, text, integer) from anon;
revoke all on function public.claim_relay(uuid, text, integer) from authenticated;
grant execute on function public.claim_relay(uuid, text, integer) to service_role;
