-- WHO THE STUDENT BELONGS TO, BEFORE ANYBODY ASKS.
--
-- Everything built so far assumes exactly one kind of user: a student, alone,
-- holding their own account. That assumption is about to become expensive in
-- three separate directions, and all three want the same shape:
--
--   * DPDP. The ledger in 0006 records answer text written by minors. Whether
--     the account holder ends up being the child or a parent is Aarav's call
--     and is deliberately still open — but the answer changes who owns a row,
--     and a schema that cannot express "this student belongs to that adult"
--     forces the decision now, badly.
--   * THE BUYER. In Indian edtech the parent usually pays. The person who buys
--     is not the person who learns, and a single-user schema has nowhere to
--     put the payer.
--   * THE LMS. A separate app on this same backend: a school or institute as
--     admin, teachers under it, students under them, with homework and exam
--     dates flowing into Curie so it can teach against a real calendar.
--
-- So: an ORGANIZATION owns people, and a MEMBERSHIP says what a person is
-- inside it. Today every student gets a private organization of one and the
-- only role ever written is 'student'. Nothing in the product changes. What
-- changes is that adding a parent, a teacher or a school later is an INSERT
-- rather than a migration across every table plus an RLS rewrite — and that
-- difference is the entire reason this lands before the ledger and not after.
--
-- The cost of being wrong in each direction is asymmetric, which is why this is
-- here at all: an unused org table costs one join that Postgres will optimise
-- away, while retrofitting tenancy onto a live table full of children's answers
-- costs a migration nobody wants to run.

create table if not exists public.organization (
  id uuid primary key default gen_random_uuid(),
  -- 'solo' is the private organization every signup gets, so that org_id is
  -- never null anywhere and no code has to special-case a student with nobody
  -- above them. 'school' is what the LMS will create.
  kind text not null default 'solo' check (kind in ('solo', 'school')),
  name text not null default 'Solo',
  created_at timestamptz not null default now()
);

create table if not exists public.membership (
  org_id uuid not null references public.organization on delete cascade,
  user_id uuid not null references auth.users on delete cascade,
  -- Only 'student' is written today. The other two exist so the check
  -- constraint does not have to be altered on the day the LMS ships.
  role text not null default 'student' check (role in ('admin', 'teacher', 'student')),
  created_at timestamptz not null default now(),
  primary key (org_id, user_id)
);

create index if not exists membership_user on public.membership (user_id);

-- ---------------------------------------------------------------------------
-- The recursion trap, and why this function exists.
--
-- The obvious policy on `membership` is "you may read rows of an org you are a
-- member of" — which reads `membership` from inside a policy ON `membership`
-- and recurses until Postgres gives up. A SECURITY DEFINER function runs with
-- the definer's rights and therefore does not re-enter RLS, which is the
-- standard way out. It is STABLE so the planner may call it once per query
-- rather than once per row.
-- ---------------------------------------------------------------------------
create or replace function public.is_member(p_org uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from public.membership m
    where m.org_id = p_org and m.user_id = auth.uid()
  );
$$;

revoke all on function public.is_member(uuid) from public;
grant execute on function public.is_member(uuid) to authenticated;

-- ---------------------------------------------------------------------------
-- Provisioning. A trigger, not app code.
--
-- Anonymous sign-in creates a user without the app ever calling a signup
-- endpoint it controls, and the ledger needs an org_id on the very first event
-- a student produces. Doing this in the client would mean a student whose first
-- write races their own provisioning, which is a bug that only appears on a
-- slow phone. Postgres is the only place that sees every user creation.
-- ---------------------------------------------------------------------------
create or replace function public.provision_solo_org()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  new_org uuid;
begin
  insert into public.organization (kind, name) values ('solo', 'Solo')
  returning id into new_org;

  insert into public.membership (org_id, user_id, role)
  values (new_org, new.id, 'student');

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.provision_solo_org();

-- ---------------------------------------------------------------------------
-- RLS. Read your own tenancy; never write it from a browser.
--
-- No insert, update or delete policy exists on either table on purpose.
-- Membership is what every other policy in 0006 trusts, so a student who could
-- write it could grant themselves a seat in someone else's school. It is
-- written by the trigger above and, later, by the LMS through service_role.
-- ---------------------------------------------------------------------------
alter table public.organization enable row level security;
alter table public.membership enable row level security;

drop policy if exists "read organizations you belong to" on public.organization;
create policy "read organizations you belong to" on public.organization
  for select
  using (public.is_member(id));

drop policy if exists "read memberships of your organizations" on public.membership;
create policy "read memberships of your organizations" on public.membership
  for select
  using (public.is_member(org_id));

-- Backfill: every account that existed before this migration also needs an org,
-- or its owner becomes unable to write a single ledger event. Idempotent, so a
-- re-run of `supabase db push` costs nothing.
insert into public.organization (id, kind, name)
select gen_random_uuid(), 'solo', 'Solo'
from auth.users u
where not exists (select 1 from public.membership m where m.user_id = u.id);

with unassigned as (
  select u.id as user_id, row_number() over (order by u.created_at) as rn
  from auth.users u
  where not exists (select 1 from public.membership m where m.user_id = u.id)
),
spare as (
  select o.id as org_id, row_number() over (order by o.created_at desc) as rn
  from public.organization o
  where not exists (select 1 from public.membership m where m.org_id = o.id)
)
insert into public.membership (org_id, user_id, role)
select spare.org_id, unassigned.user_id, 'student'
from unassigned join spare on spare.rn = unassigned.rn;
