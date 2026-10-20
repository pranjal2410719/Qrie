-- WHAT EACH CALL COST, IN THE UNITS THE PROVIDER BILLS.
--
-- Phase 2 of the closed-loop plan prices a credit. It refuses to do that from
-- an estimate: "measure cost per class and per student-hour FIRST, price
-- second" is the phase's opening line. This is the measuring.
--
-- relay_usage (0003) is a METER - may this student make another call - and it
-- counts in units invented for that purpose. It cannot say what a class cost.
-- Vertex tells the relay the token counts on every reply, the speech relay
-- holds the text it sends, the transcriber holds the audio it receives; all of
-- it was in hand on every call and none of it was written down.
--
-- QUANTITIES HERE, PRICES THERE. usage_event holds tokens, characters, bytes -
-- facts about a call that cannot change. model_price holds rupees per unit - a
-- fact about a contract that changes without telling us. Cost is the join,
-- done at read time, so a price update re-prices history correctly and a
-- price hard-coded into a function does not go quietly stale.

create table if not exists public.usage_event (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users on delete cascade,
  -- The learning session, when the app said which. Not a foreign key: the
  -- session row is written by the ledger drain and may land AFTER the calls
  -- that belonged to it, and a usage row must never be refused for that.
  session_id uuid,
  at timestamptz not null default now(),
  relay text not null check (relay in ('llm', 'speech', 'hear', 'class', 'icons')),
  provider text not null check (provider in ('vertex', 'openrouter', 'storage')),
  model text,
  -- Upstream status. 0 means dispatched without a visible outcome (a stream
  -- the host carried). A failed call is a row, so failure has a cost too.
  status integer not null default 0,
  prompt_tokens integer check (prompt_tokens is null or prompt_tokens >= 0),
  output_tokens integer check (output_tokens is null or output_tokens >= 0),
  thought_tokens integer check (thought_tokens is null or thought_tokens >= 0),
  images integer check (images is null or images >= 0),
  characters integer check (characters is null or characters >= 0),
  audio_bytes integer check (audio_bytes is null or audio_bytes >= 0),
  bytes integer check (bytes is null or bytes >= 0)
);

create index if not exists usage_event_user_at on public.usage_event (user_id, at desc);
create index if not exists usage_event_session on public.usage_event (session_id) where session_id is not null;

-- ---------------------------------------------------------------------------
-- Prices. Filled by an operator from the provider's own page; never by code.
-- ---------------------------------------------------------------------------
create table if not exists public.model_price (
  provider text not null,
  model text not null,
  unit text not null check (unit in (
    'prompt_token', 'output_token', 'thought_token', 'image', 'character', 'audio_second', 'byte'
  )),
  inr_per_unit numeric not null check (inr_per_unit >= 0),
  -- A price change is a NEW row. History keeps the price it was billed at.
  effective_from timestamptz not null default now(),
  note text,
  primary key (provider, model, unit, effective_from)
);

-- ---------------------------------------------------------------------------
-- The write, service_role only - the same door the meter uses.
-- ---------------------------------------------------------------------------
create or replace function public.record_usage(
  p_user uuid,
  p_session uuid,
  p_relay text,
  p_provider text,
  p_model text,
  p_status integer,
  p_prompt_tokens integer,
  p_output_tokens integer,
  p_thought_tokens integer,
  p_images integer,
  p_characters integer,
  p_audio_bytes integer,
  p_bytes integer
) returns void
language sql
security definer
set search_path = public
as $$
  insert into public.usage_event (
    user_id, session_id, relay, provider, model, status,
    prompt_tokens, output_tokens, thought_tokens, images, characters, audio_bytes, bytes
  ) values (
    p_user, p_session, p_relay, p_provider, p_model, coalesce(p_status, 0),
    p_prompt_tokens, p_output_tokens, p_thought_tokens, p_images, p_characters, p_audio_bytes, p_bytes
  );
$$;

revoke all on function public.record_usage(uuid, uuid, text, text, text, integer, integer, integer, integer, integer, integer, integer, integer) from public;
revoke all on function public.record_usage(uuid, uuid, text, text, text, integer, integer, integer, integer, integer, integer, integer, integer) from anon;
revoke all on function public.record_usage(uuid, uuid, text, text, text, integer, integer, integer, integer, integer, integer, integer, integer) from authenticated;
grant execute on function public.record_usage(uuid, uuid, text, text, text, integer, integer, integer, integer, integer, integer, integer, integer) to service_role;

-- ---------------------------------------------------------------------------
-- RLS. A student may read their own usage - a "what did I spend" screen is a
-- Phase 4 item - and nobody but the relay writes it.
-- ---------------------------------------------------------------------------
alter table public.usage_event enable row level security;
alter table public.model_price enable row level security;

drop policy if exists "read your own usage" on public.usage_event;
create policy "read your own usage" on public.usage_event
  for select using (auth.uid() = user_id);

drop policy if exists "anyone may read prices" on public.model_price;
create policy "anyone may read prices" on public.model_price
  for select using (true);

-- ---------------------------------------------------------------------------
-- COST, AS A JOIN. This is the number Phase 2 was waiting for.
-- ---------------------------------------------------------------------------

-- The price in force when the call happened. Null when nobody has entered one,
-- which propagates as a null cost - visibly unpriced, never silently free.
create or replace function public.price_at(
  p_provider text, p_model text, p_unit text, p_at timestamptz
) returns numeric
language sql
stable
set search_path = public
as $$
  select inr_per_unit
    from public.model_price
   where provider = p_provider and model = p_model and unit = p_unit
     and effective_from <= p_at
   order by effective_from desc
   limit 1;
$$;

-- Audio arrives as 16 kHz, 16-bit, mono WAV from the ear - 32,000 bytes per
-- second. If the ear ever changes its format this constant is the one place
-- that has to follow it.
create or replace view public.usage_cost as
select
  e.*,
  (
    coalesce(e.prompt_tokens  * public.price_at(e.provider, e.model, 'prompt_token',  e.at), 0)
  + coalesce(e.output_tokens  * public.price_at(e.provider, e.model, 'output_token',  e.at), 0)
  + coalesce(e.thought_tokens * public.price_at(e.provider, e.model, 'thought_token', e.at), 0)
  + coalesce(e.images         * public.price_at(e.provider, e.model, 'image',         e.at), 0)
  + coalesce(e.characters     * public.price_at(e.provider, e.model, 'character',     e.at), 0)
  + coalesce((e.audio_bytes / 32000.0) * public.price_at(e.provider, e.model, 'audio_second', e.at), 0)
  + coalesce(e.bytes          * public.price_at(e.provider, e.model, 'byte',          e.at), 0)
  ) as inr,
  -- True when at least one quantity on this row has no price yet, so a report
  -- can say "this total is a floor" instead of presenting a hole as a saving.
  (
    (e.prompt_tokens  is not null and public.price_at(e.provider, e.model, 'prompt_token',  e.at) is null) or
    (e.output_tokens  is not null and public.price_at(e.provider, e.model, 'output_token',  e.at) is null) or
    (e.images         is not null and public.price_at(e.provider, e.model, 'image',         e.at) is null) or
    (e.characters     is not null and public.price_at(e.provider, e.model, 'character',     e.at) is null) or
    (e.audio_bytes    is not null and public.price_at(e.provider, e.model, 'audio_second',  e.at) is null)
  ) as unpriced
from public.usage_event e;

-- What one sitting cost, in rupees, and whether any of it is still unpriced.
create or replace function public.session_cost(p_session uuid)
returns table (inr numeric, calls bigint, unpriced_calls bigint)
language sql
stable
set search_path = public
as $$
  select coalesce(sum(inr), 0), count(*), count(*) filter (where unpriced)
    from public.usage_cost
   where session_id = p_session;
$$;

-- THE HEADLINE NUMBER: rupees per hour of a student actually learning.
--
-- Joins usage to the ledger's learning_session so the denominator is time ON
-- TASK (active_ms), not wall clock. Only closed sessions with a measured
-- active_ms count - an open session has no denominator yet.
create or replace function public.cost_per_student_hour(p_days integer default 30)
returns table (
  sessions bigint,
  active_hours numeric,
  inr numeric,
  inr_per_hour numeric,
  unpriced_calls bigint
)
language sql
stable
security definer
set search_path = public
as $$
  with closed as (
    select id, active_ms
      from public.learning_session
     where ended_at is not null
       and active_ms is not null and active_ms > 0
       and received_at >= now() - make_interval(days => greatest(p_days, 1))
  ),
  spend as (
    select c.id, coalesce(sum(u.inr), 0) as inr, count(u.*) filter (where u.unpriced) as unpriced
      from closed c
      left join public.usage_cost u on u.session_id = c.id
     group by c.id
  )
  select
    count(*)::bigint,
    round(sum(c.active_ms) / 3600000.0, 3),
    round(coalesce(sum(s.inr), 0), 4),
    case when sum(c.active_ms) > 0
         then round(coalesce(sum(s.inr), 0) / (sum(c.active_ms) / 3600000.0), 4)
         else null end,
    coalesce(sum(s.unpriced), 0)::bigint
  from closed c join spend s on s.id = c.id;
$$;

revoke all on function public.cost_per_student_hour(integer) from public;
revoke all on function public.cost_per_student_hour(integer) from anon;
revoke all on function public.cost_per_student_hour(integer) from authenticated;
grant execute on function public.cost_per_student_hour(integer) to service_role;
