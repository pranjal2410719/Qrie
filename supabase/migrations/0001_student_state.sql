-- The student's work, one row per store per student.
--
-- A row rather than a column each: stores are added and changed often, and a
-- schema migration per store would make adding one a deploy. `key` is the
-- store's own localStorage key, so the two sides need no mapping table.
create table if not exists public.student_state (
  user_id uuid not null references auth.users on delete cascade,
  key text not null,
  value jsonb not null,
  updated_at bigint not null,
  primary key (user_id, key)
);

-- WITHOUT THIS EVERY STUDENT CAN READ EVERY OTHER STUDENT'S WORK.
--
-- The policy used to exist only as a docstring in the client. A comment is
-- not a permission: until these two statements run on the project, the anon
-- key that ships in the bundle can select the whole table.
alter table public.student_state enable row level security;

drop policy if exists "own rows" on public.student_state;
create policy "own rows" on public.student_state
  for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
