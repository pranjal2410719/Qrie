-- Migration 0015: School structure, classes, enrollments, and teacher assignments.
-- Enables database-backed LMS workflows for Admin and Teacher modules with tenant isolation.

create table if not exists public.school (
  id text primary key,
  name text not null,
  code text not null unique,
  academic_year text not null default '2026-2027',
  status text not null default 'active' check (status in ('active', 'inactive', 'archived')),
  created_at timestamptz not null default now()
);

create table if not exists public.school_class (
  id text primary key,
  school_id text not null,
  grade integer not null check (grade between 1 and 12),
  section text not null,
  name text not null,
  subject text not null default 'Mathematics',
  academic_year text not null default '2026-2027',
  created_at timestamptz not null default now()
);

create index if not exists school_class_school_idx on public.school_class (school_id);

create table if not exists public.student_enrollment (
  id text primary key,
  school_id text not null,
  class_id text not null references public.school_class(id) on delete cascade,
  full_name text not null,
  email text not null,
  grade integer not null check (grade between 1 and 12),
  roll_number text not null,
  lam_student_id text not null,
  overall_mastery numeric(4, 3) not null default 0.700,
  status text not null default 'on_track' check (status in ('on_track', 'struggling', 'advanced')),
  active_struggles jsonb not null default '[]'::jsonb,
  last_active timestamptz not null default now(),
  created_at timestamptz not null default now()
);

create index if not exists student_enrollment_class_idx on public.student_enrollment (class_id);
create index if not exists student_enrollment_school_idx on public.student_enrollment (school_id);

create table if not exists public.teacher_assignment (
  id text primary key default gen_random_uuid()::text,
  school_id text not null,
  teacher_id text not null,
  class_id text not null references public.school_class(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (teacher_id, class_id)
);

create index if not exists teacher_assignment_teacher_idx on public.teacher_assignment (teacher_id);
create index if not exists teacher_assignment_school_idx on public.teacher_assignment (school_id);
