-- WHAT THE STUDENT ACTUALLY DID, KEPT.
--
-- Today, a student answering a question in class produces exactly this:
--
--   answeredRight[outcomeId] += 1
--
-- A counter. Thrown away at that instant: which option they picked, what they
-- SAID, how long they took, which attempt this was, whether a hint had already
-- been given, the judge's reason, the named misconception, and the time. The
-- practice quiz is worse — it computes a full per-question row including the
-- misconception and persists {lessonRef, score, total, at}.
--
-- Five of the sixteen systems in the product brief are functions of that
-- discarded data: misconception diagnosis, assisted-vs-unassisted mastery,
-- spaced retrieval, metacognitive calibration, and the learning scientist. So
-- is the primary metric, unassisted mastery gain per learning minute.
--
-- Everything else in the plan can be built in any order. THIS CANNOT BE
-- BACKFILLED. Every class taught before this table exists is a class whose
-- evidence is gone, and that is the whole argument for building it before the
-- things it feeds.

-- ---------------------------------------------------------------------------
-- A sitting. One class, one quiz, one placement test, one doubt.
-- ---------------------------------------------------------------------------
create table if not exists public.learning_session (
  -- Client-minted, like every id here: the device has to name a session before
  -- it can queue events against it, and it may be offline when it does.
  id uuid primary key,
  org_id uuid not null references public.organization on delete cascade,
  user_id uuid not null references auth.users on delete cascade,
  source text not null check (source in ('class', 'quiz', 'diagnostic', 'doubt')),
  topic_ref text,
  started_at timestamptz not null,
  ended_at timestamptz,

  -- TIME ON TASK, not wall clock. The primary metric is per LEARNING MINUTE,
  -- and a class left open on a table while someone eats dinner is not learning.
  -- Measured by the client as the sum of periods where the page was visible and
  -- the class was actually advancing. Without this the headline metric cannot be
  -- computed at all, which is how a product quietly falls back to "engagement".
  active_ms integer check (active_ms is null or active_ms >= 0),

  received_at timestamptz not null default now()
);

create index if not exists learning_session_user on public.learning_session (user_id, started_at desc);

-- ---------------------------------------------------------------------------
-- The events. Append-only, and idempotent on replay.
-- ---------------------------------------------------------------------------
create table if not exists public.ledger_event (
  -- THE IDEMPOTENCY KEY, and the reason the outbox is safe. The device mints a
  -- uuid when the event happens, not when it is sent. A drain that fails
  -- halfway, a retry after a dead tunnel, an app killed mid-flush — all replay
  -- the same rows, and `on conflict (id) do nothing` makes that a no-op instead
  -- of a duplicate answer inflating a student's mastery.
  id uuid primary key,

  org_id uuid not null references public.organization on delete cascade,
  user_id uuid not null references auth.users on delete cascade,
  session_id uuid not null,

  -- Monotonic within a session. Ordering cannot rely on `at`, because `at` is a
  -- phone's clock and phones lie — a device with a skewed clock would otherwise
  -- shuffle its own session into nonsense.
  seq integer not null check (seq >= 0),

  -- Two clocks, deliberately. `at` is the device's, and is EXPLICITLY UNTRUSTED:
  -- it is what the student's phone believed, which is the right thing for
  -- reconstructing their experience and the wrong thing for anything else.
  -- `received_at` is Postgres's and is what any billing, rate or audit question
  -- must use.
  at timestamptz not null,
  received_at timestamptz not null default now(),

  kind text not null check (kind in (
    'session-started', 'session-ended',
    'asked', 'answered', 'helped',
    'taught', 'confused',
    'intervened', 'reflected'
  )),
  source text not null check (source in ('class', 'quiz', 'diagnostic', 'doubt')),
  surface text not null check (surface in ('tap', 'voice', 'text')),

  -- Learning Outcome Map node ids this event speaks about. Empty is legal and
  -- common: a hook beat teaches nothing, and an event about it still belongs in
  -- the record.
  outcome_ids text[] not null default '{}',
  topic_ref text,

  -- Everything kind-specific. Typed in packages/ledger rather than here,
  -- because the shapes will grow — assistance rungs, misconception ids,
  -- intervention reasons — and each growth must not be a migration.
  --
  -- WHAT MAY GO IN, settled 2026-09-12: the judge's verdict, the misconception
  -- id, and a trimmed, capped, normalised form of the student's answer. NEVER
  -- audio, never free conversation, never a turn the safety screen flagged. A
  -- classification-only ledger would make the judge permanently unauditable —
  -- a misclassification would be invisible forever and could never be retrained
  -- — which is why some of the words are kept and why the limits are tight.
  --
  -- A cross-question ('reflected') adds three, listed here rather than left to
  -- be discovered in a payload: whether their reasoning held, a trimmed and
  -- capped form of that REASONING, and the tutor's own question. The first two
  -- are the same bargain as an answer, against words screened the same way.
  -- The third is hers, not the child's, and is kept because without it the
  -- stored reasoning answers a question nobody wrote down — capped and
  -- stripped all the same, by `normaliseTutorText` in packages/ledger.
  payload jsonb not null default '{}'
);

-- A device that replays its outbox must not be able to write two different
-- events at the same position in a session.
create unique index if not exists ledger_event_session_seq
  on public.ledger_event (session_id, seq);

-- The two reads that matter: one student's history, and one session's replay.
create index if not exists ledger_event_user_at on public.ledger_event (user_id, at desc);
create index if not exists ledger_event_session on public.ledger_event (session_id, seq);

-- ---------------------------------------------------------------------------
-- RLS. Append-only is enforced by ABSENCE.
--
-- There is a select policy and an insert policy and deliberately NO update or
-- delete policy on either table. A record that can be edited is not a record;
-- the learner model is rebuilt from these rows, so a student able to revise
-- history could revise what the system believes about them. Deletion happens
-- through account deletion and the retention job, both service_role.
--
-- The insert policy pins BOTH halves: the row must be yours AND the org must be
-- one you belong to. Checking only user_id would let a student file their
-- answers into someone else's school.
--
-- KNOWN LIMIT, written down rather than discovered later: a determined student
-- can still POST an event claiming they answered correctly. That is not new —
-- the entire learner model lives in their localStorage today, so this is
-- strictly harder to forge than what it replaces — and it harms only their own
-- plan. It stops being acceptable the moment a ledger row is worth money or a
-- certificate, at which point answers move behind the relay and are graded
-- server-side. That is a Phase 2 concern and it is on the record here.
-- ---------------------------------------------------------------------------
alter table public.learning_session enable row level security;
alter table public.ledger_event enable row level security;

drop policy if exists "read your own sessions" on public.learning_session;
create policy "read your own sessions" on public.learning_session
  for select using (auth.uid() = user_id);

drop policy if exists "append your own sessions" on public.learning_session;
create policy "append your own sessions" on public.learning_session
  for insert with check (auth.uid() = user_id and public.is_member(org_id));

drop policy if exists "read your own events" on public.ledger_event;
create policy "read your own events" on public.ledger_event
  for select using (auth.uid() = user_id);

drop policy if exists "append your own events" on public.ledger_event;
create policy "append your own events" on public.ledger_event
  for insert with check (auth.uid() = user_id and public.is_member(org_id));

-- A session's end is the one legitimate update — active_ms is only known when
-- the class stops. It is a function rather than an update policy so that the
-- ONLY mutable field is the one that has to be, and a session can be closed
-- exactly once.
create or replace function public.close_learning_session(
  p_session uuid,
  p_ended_at timestamptz,
  p_active_ms integer
) returns void
language sql
security definer
set search_path = public
as $$
  update public.learning_session
     set ended_at = p_ended_at, active_ms = p_active_ms
   where id = p_session
     and user_id = auth.uid()
     and ended_at is null;
$$;

revoke all on function public.close_learning_session(uuid, timestamptz, integer) from public;
grant execute on function public.close_learning_session(uuid, timestamptz, integer) to authenticated;
