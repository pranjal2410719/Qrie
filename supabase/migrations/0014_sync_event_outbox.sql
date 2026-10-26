-- DAY 2: A DURABLE HANDOFF FOR THE MOBILE OUTBOX.
--
-- `POST /api/v1/sync/events` used to acknowledge event ids without storing
-- anything. A 200 meant "the request parsed", not "the evidence survives a
-- restart", so a dropped response or a backend crash lost the batch while the
-- client had already deleted its local copy.
--
-- This table is that handoff. It is deliberately a BRIDGE, not the canonical
-- ledger: `public.ledger_event` (0006) is the append-only record, and it keys
-- tenancy on uuid org/user/session ids. The Fastify backend still uses the
-- fixture text ids from its JWT claims (`sch_dps_rkp`, `std_aarav_patel`), so it
-- cannot write there yet. Keeping the bridge here makes the handoff durable
-- now; moving to `ledger_event` later is a data move, not a redesign.
--
-- Idempotency is the primary key. The device mints `event_id` when the event
-- happens, not when it is sent, so a replay after a dead tunnel hits
-- `on conflict (org_id, event_id) do nothing` instead of double-counting.
-- Tenancy is part of the key: the same id from two schools is two rows.

create table if not exists public.sync_event (
  org_id text not null,
  user_id text not null,
  event_id text not null,

  -- Resolved at ingest. Null is legal: an event can be stored even when it is
  -- not eligible to become learner evidence, and `relay_status` records why.
  session_id text,

  -- The event type exactly as the client sent it (`learning.answer_submitted`
  -- or a canonical LAM type). `payload` keeps the original body so the mapping
  -- to LAM can be re-evaluated without a rewrite.
  event_type text not null,
  payload jsonb not null default '{}'::jsonb,

  -- Device clock, explicitly untrusted. `received_at` is the server clock and
  -- is what retry ordering uses.
  occurred_at timestamptz,
  received_at timestamptz not null default now(),

  -- pending    - stored, eligible or not yet attempted, retryable
  -- processing - claimed by an active relay execution (in flight)
  -- relayed    - accepted by LAM
  -- skipped    - stored but ineligible to become evidence (terminal)
  -- failed     - retry budget exhausted (terminal)
  relay_status text not null default 'pending'
    check (relay_status in ('pending', 'processing', 'relayed', 'skipped', 'failed')),
  relay_attempts integer not null default 0 check (relay_attempts >= 0),
  relayed_at timestamptz,
  last_error text,

  primary key (org_id, event_id)
);

-- The drain query: one student's retryable rows, oldest first.
create index if not exists sync_event_pending
  on public.sync_event (org_id, user_id, received_at)
  where relay_status = 'pending';

-- RLS with NO policies on purpose. The backend connects with the table owner
-- role, which bypasses RLS; `anon` and `authenticated` get nothing. Adding a
-- permissive policy here would expose every school's outbox through PostgREST.
alter table public.sync_event enable row level security;

comment on table public.sync_event is
  'Durable outbox handoff for POST /api/v1/sync/events. Bridge to public.ledger_event; see migration 0014 notes.';
