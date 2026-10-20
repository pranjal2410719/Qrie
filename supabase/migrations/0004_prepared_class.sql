-- CLASSES THE TUTOR MADE, KEPT FOR WHOEVER COMES NEXT.
--
-- The economics of this whole product rest on one sentence from the ship plan:
-- a recording is a CACHE of the first live class, not a lesser product. A topic
-- is prepared once, for about ₹2.25 and fifty seconds, and every student after
-- that gets it for the cost of a download.
--
-- In development a prepared class is written into content/ as ordinary files by
-- a vite plugin. In production there is no filesystem to write to, so it went
-- nowhere at all — /api/class answered 501 and every student re-prepared every
-- topic they touched. This is where it goes instead.
--
-- Two halves, deliberately:
--   * the FILES (lesson.json, assets.json, generated pictures) go to Storage,
--     because they are content and a bucket serves them over a CDN;
--   * the CATALOGUE ROW lives here, because the app has to be able to ask "has
--     anybody had this class?" without listing a bucket.

create table if not exists public.prepared_class (
  -- Slugified topicRef, from class-prep's idFor(). The same topic is always
  -- the same id, which is what makes a second preparation a duplicate rather
  -- than a second copy.
  id text primary key,
  -- "<syllabusId>/<chapterId>/<topicId>" — THE join key of the product, the
  -- same one the outcome map and the chapter screen address content by.
  topic_ref text not null unique,
  title text not null,
  subtitle text,
  klass integer not null,
  subject text not null,
  created_at timestamptz not null default now()
);

-- The catalogue is read on every home screen and every chapter.
create index if not exists prepared_class_klass_subject
  on public.prepared_class (klass, subject);

alter table public.prepared_class enable row level security;

-- EVERYONE MAY READ. This is curriculum, not somebody's work: the whole point
-- is that a class one student paid to make is free for the next one. Nothing
-- in the row is personal — saveable() refuses to keep a class whose spine
-- carries a student's name (packages/class-prep/src/save.ts).
drop policy if exists "anyone may read prepared classes" on public.prepared_class;
create policy "anyone may read prepared classes" on public.prepared_class
  for select
  using (true);

-- And NOBODY may write, except the relay running as service_role. A student's
-- browser must not be able to add a row that points every later student at a
-- lesson file of its choosing.

-- ---------------------------------------------------------------------------
-- The bucket the files live in.
-- ---------------------------------------------------------------------------

-- The relay caps a whole class at 12 MB and 24 files. This is the second
-- fence, on the object rather than the request: a bug on our side that lets a
-- larger upload through still cannot fill a bucket one file at a time.
insert into storage.buckets (id, name, public, file_size_limit)
values ('classes', 'classes', true, 12582912)
on conflict (id) do update set file_size_limit = excluded.file_size_limit;

-- Public READ, because a lesson is meant to be fetched by a browser with no
-- session — the same way content/ is served today. Writes are service_role
-- only, which is the default and is not granted below.
drop policy if exists "anyone may read a prepared class file" on storage.objects;
create policy "anyone may read a prepared class file" on storage.objects
  for select
  using (bucket_id = 'classes');
