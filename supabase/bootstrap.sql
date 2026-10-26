-- Bootstrap schema definitions for vanilla PostgreSQL (CI / local testing)
-- Stubs out Supabase-managed roles, auth, storage, and cron extensions.

create extension if not exists "pgcrypto";

-- 1. Standard Supabase Roles
do $$
begin
  if not exists (select from pg_roles where rolname = 'anon') then
    create role anon;
  end if;
  if not exists (select from pg_roles where rolname = 'authenticated') then
    create role authenticated;
  end if;
  if not exists (select from pg_roles where rolname = 'service_role') then
    create role service_role;
  end if;
end $$;

-- 2. Auth Schema
create schema if not exists auth;

create table if not exists auth.users (
  id uuid primary key default gen_random_uuid(),
  email text unique,
  raw_app_meta_data jsonb default '{}'::jsonb,
  raw_user_meta_data jsonb default '{}'::jsonb,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create or replace function auth.uid()
returns uuid
language sql
stable
as $$
  select null::uuid;
$$;

-- 3. Storage Schema
create schema if not exists storage;

create table if not exists storage.buckets (
  id text primary key,
  name text not null,
  public boolean default false,
  file_size_limit bigint,
  allowed_mime_types text[],
  owner uuid references auth.users(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists storage.objects (
  id uuid primary key default gen_random_uuid(),
  bucket_id text references storage.buckets(id),
  name text,
  owner uuid references auth.users(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  last_accessed_at timestamptz default now(),
  metadata jsonb
);

-- 4. Cron Schema Stubs (fallback when pg_cron binary is not loaded)
create schema if not exists cron;
create or replace function cron.schedule(text, text, text) returns bigint language sql as $$ select 1::bigint; $$;
create or replace function cron.unschedule(text) returns boolean language sql as $$ select true; $$;
