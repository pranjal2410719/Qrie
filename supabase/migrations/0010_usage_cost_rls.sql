-- ---------------------------------------------------------------------------
-- A VIEW DOES NOT INHERIT THE ROW SECURITY OF THE TABLE UNDER IT.
--
-- `usage_event` has own-rows RLS and it works: a student selecting from it
-- gets their own rows and nobody else's, and the live test has proved that
-- since the day it shipped.
--
-- `usage_cost` selects from `usage_event`. In Postgres a view runs with the
-- rights of the role that DEFINED it unless it says otherwise, and the role
-- that defines a migration here is the one RLS does not apply to. So the view
-- read every student's rows, and Supabase grants `select` on new objects in
-- `public` to `anon` and `authenticated` by default — which meant any signed-in
-- student could read the whole table through it.
--
-- Measured, not reasoned about: a brand-new anonymous account selecting from
-- `usage_cost` came back with five other students' rows, while the same account
-- selecting from `usage_event` correctly came back with none. What leaked is
-- every student's session ids, which models they used, when, and how much.
--
-- Two fixes, because either alone would be one mistake away from the same hole:
-- the view now runs as its CALLER, so RLS applies to it like anything else; and
-- it is revoked from students outright, because it is an operator's report and
-- was never meant to be reachable from a browser at all.
-- ---------------------------------------------------------------------------

alter view public.usage_cost set (security_invoker = true);

revoke all on public.usage_cost from public;
revoke all on public.usage_cost from anon;
revoke all on public.usage_cost from authenticated;
grant select on public.usage_cost to service_role;

-- `session_cost` reads the same view and was the one function in 0008 that
-- nobody revoked, so a student could hand it any session id at all — including
-- somebody else's — and be told what that sitting cost. Its two neighbours,
-- `record_usage` and `cost_per_student_hour`, were both closed on the same
-- reasoning; this one was simply missed.
revoke all on function public.session_cost(uuid) from public;
revoke all on function public.session_cost(uuid) from anon;
revoke all on function public.session_cost(uuid) from authenticated;
grant execute on function public.session_cost(uuid) to service_role;

-- `cost_per_student_hour` stays SECURITY DEFINER on purpose: it is the
-- operator's own report across every student, it is already granted to
-- service_role alone, and it must keep seeing all rows through the view now
-- that the view has stopped showing them to everyone.
