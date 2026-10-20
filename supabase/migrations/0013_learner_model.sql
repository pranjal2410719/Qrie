-- WHAT WE BELIEVE ABOUT A STUDENT, PER OUTCOME.
--
-- Until now belief was a flat node-id -> float map living as a sub-field of the
-- last placement test's result, inside one localStorage blob that also holds the
-- student's name and class and shares its one updated_at with them. It reaches
-- Postgres today only as opaque jsonb in student_state, whole-blob
-- last-write-wins, so two devices lose each other's beliefs outright. It is
-- ~195 KB for a Class 10 Science+Maths student, and a quota failure writing it
-- is swallowed silently.
--
-- WRITTEN ONLY BY service_role. A student may read their own beliefs and cannot
-- write them. That is deliberately stricter than student_state, whose policy is
-- `for all` — a student can delete and rewrite their own synced blob at will.
-- Belief here is DERIVED from the ledger, and the ledger is append-only; a
-- belief a student can set is not evidence about anything.

create table if not exists public.concept_state (
  -- org_id from day one. Only membership, learning_session and ledger_event
  -- carry it today, so this establishes a NEW pattern for a per-student table
  -- rather than following an existing one — student_state, relay_usage,
  -- prepared_class, usage_event and model_price all lack it. It is worth the
  -- column because adding is_member(org_id) the day a teacher exists is then a
  -- policy change, rather than a migration across a table holding every
  -- student's beliefs.
  org_id uuid not null references public.organization on delete cascade,
  user_id uuid not null references auth.users on delete cascade,
  outcome_id text not null,

  -- All evidence, assisted or not.
  mastery real not null,
  -- Rung 0 only: the number that means they can do it without us.
  unassisted_mastery real not null,
  -- How they do WITH help. High here beside a low unassisted_mastery is the
  -- signal the whole phase exists to produce.
  assisted_performance real not null,

  observations integer not null default 0,
  -- Counted apart, because without it "unassisted mastery 0.5" and "nobody has
  -- ever asked them cold" are the same number and they are not the same fact.
  unassisted_observations integer not null default 0,
  -- Durable across sittings, because applyTaught saturates on this count.
  -- Diagnostic.tsx applies attendance twice today for want of somewhere to keep
  -- it, and attendance alone can then carry a node from the prior to nearly
  -- settled on zero answered questions.
  taught_count integer not null default 0,

  last_practiced_at timestamptz,
  last_unassisted_success_at timestamptz,

  -- WRITTEN FROM DAY ONE AND NOT DRIVEN UNTIL PHASE 6. Present so that turning
  -- spaced retrieval on is wiring rather than a migration across what will be
  -- the largest per-student table in the product.
  memory_strength real not null default 0,
  next_review_at timestamptz,
  retrieval_count integer not null default 0,
  retrieval_accuracy real not null default 0,

  updated_at timestamptz not null default now(),

  primary key (user_id, outcome_id)
);

-- The model is read per student, weakest first — that is what chooseAsk and the
-- inspector both want. Without this, every read of a student's model is a scan
-- of every student's.
create index if not exists concept_state_user_idx
  on public.concept_state (user_id, unassisted_mastery);

-- ONE ROW PER STUDENT: how far the fold has consumed their history.
create table if not exists public.learner_model (
  user_id uuid primary key references auth.users on delete cascade,
  org_id uuid not null references public.organization on delete cascade,

  -- The cursor, as (learning_session.started_at, ledger_event.seq). Two columns
  -- rather than jsonb because it is compared on every fold, and because a
  -- comparison against a jsonb field is the kind of thing that works until the
  -- planner stops using an index.
  folded_through_at timestamptz,
  folded_through_seq integer,

  -- Of ConceptState's shape. Kept in step with MODEL_VERSION in
  -- packages/learner-model/src/types.ts, and asserted by
  -- apps/classroom/tests/migrations.test.ts — the same drift check the day
  -- budget has, for the same reason.
  version integer not null default 1,

  updated_at timestamptz not null default now()
);

-- THE INDEX THE INSPECTOR NEEDS AND NOTHING ELSE HAS.
--
-- ledger_event.outcome_ids has no index of any kind. The fold does not need one
-- — it reads by session in seq order, which the existing indexes serve — but
-- "what evidence is behind this outcome?" has no other access path, and that is
-- the question the whole model exists to answer.
create index if not exists ledger_event_outcomes_idx
  on public.ledger_event using gin (outcome_ids);

alter table public.concept_state enable row level security;
alter table public.learner_model enable row level security;

-- A STUDENT MAY READ THEIR OWN AND NOTHING ELSE.
--
-- There is no insert, update or delete policy, and their ABSENCE is the point:
-- RLS denies what no policy allows, so the only writer is service_role through
-- the fold. Adding one later would not be a small change; it would make every
-- number in this table a claim rather than a measurement.
drop policy if exists "a student reads their own concept state" on public.concept_state;
create policy "a student reads their own concept state" on public.concept_state
  for select to authenticated using (auth.uid() = user_id);

drop policy if exists "a student reads their own model row" on public.learner_model;
create policy "a student reads their own model row" on public.learner_model
  for select to authenticated using (auth.uid() = user_id);

-- Supabase grants select on new objects in public to anon and authenticated
-- automatically — 0010 found that the hard way, with a view that handed a
-- brand-new anonymous account five other students' spend. RLS above already
-- filters, but anon has no business reaching these at all, and a revoke that is
-- merely redundant costs nothing.
revoke all on public.concept_state from anon;
revoke all on public.learner_model from anon;
revoke insert, update, delete on public.concept_state from authenticated;
revoke insert, update, delete on public.learner_model from authenticated;
