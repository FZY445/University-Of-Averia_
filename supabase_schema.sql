-- University of Averiá — V6.4.1 database schema
-- Run this entire script in Supabase SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.pmb_applications (
  id uuid primary key default gen_random_uuid(),
  exam_code text not null unique,
  name text not null,
  faculty text not null,
  program text,
  interests jsonb not null default '[]'::jsonb,
  talents jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists public.online_exam_results (
  id uuid primary key default gen_random_uuid(),
  exam_code text not null,
  name text not null,
  faculty text not null,
  score integer not null check (score between 0 and 100),
  correct integer not null check (correct between 0 and 25),
  completed_at timestamptz not null default now()
);

create index if not exists online_exam_results_score_idx
  on public.online_exam_results (score desc, completed_at asc);

alter table public.pmb_applications enable row level security;
alter table public.online_exam_results enable row level security;

drop policy if exists "public can submit PMB" on public.pmb_applications;
create policy "public can submit PMB"
  on public.pmb_applications for insert
  to anon, authenticated
  with check (true);

-- PMB applications are intentionally NOT publicly readable.

drop policy if exists "public can submit online exam" on public.online_exam_results;
create policy "public can submit online exam"
  on public.online_exam_results for insert
  to anon, authenticated
  with check (true);

drop policy if exists "public can view online leaderboard" on public.online_exam_results;
create policy "public can view online leaderboard"
  on public.online_exam_results for select
  to anon, authenticated
  using (true);
