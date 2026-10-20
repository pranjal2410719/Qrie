-- Deleting an account, for real.
--
-- Both stores require it — Apple since June 2022, Google in-app and on the
-- web — and "Reset progress" only ever cleared local state, leaving the user
-- and every row of their work behind. A client cannot delete an auth user
-- with the anon key, and it must not be given a key that could: so the
-- deletion happens here, under the caller's own identity, and the cascade on
-- student_state does the rest.
create or replace function public.delete_own_account()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'not signed in';
  end if;
  -- student_state references auth.users on delete cascade, so the work goes
  -- with the account rather than being orphaned under a dead id.
  delete from auth.users where id = auth.uid();
end;
$$;

revoke all on function public.delete_own_account() from public;
grant execute on function public.delete_own_account() to authenticated;
