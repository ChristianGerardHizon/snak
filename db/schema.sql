-- Snak — Supabase schema for students + health records + health reports
-- Defaults: K-12 school context, soft-delete, RLS on with permissive policies (auth deferred).
-- Run in Supabase SQL editor. Idempotent-ish (uses IF NOT EXISTS where possible).

-- ---------------------------------------------------------------------------
-- Extensions
-- ---------------------------------------------------------------------------
create extension if not exists "pgcrypto";

-- ---------------------------------------------------------------------------
-- Helper: updated_at trigger
-- ---------------------------------------------------------------------------
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- ---------------------------------------------------------------------------
-- students
-- ---------------------------------------------------------------------------
create table if not exists public.students (
  id              uuid primary key default gen_random_uuid(),
  first_name      text not null,
  last_name       text not null,
  middle_name     text,
  date_of_birth   date,
  sex             text check (sex in ('male','female','other')),
  grade_level     text,                 -- e.g., 'Grade 7'
  section         text,                 -- e.g., 'Sampaguita'
  student_number  text unique,
  contact_phone   text,
  contact_email   text,
  guardian_name   text,
  guardian_phone  text,
  address         text,
  photo_url       text,
  notes           text,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now(),
  deleted_at      timestamptz
);

create index if not exists students_last_name_idx on public.students (last_name);
create index if not exists students_grade_section_idx on public.students (grade_level, section);
create index if not exists students_deleted_at_idx on public.students (deleted_at);

drop trigger if exists trg_students_updated_at on public.students;
create trigger trg_students_updated_at
before update on public.students
for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- health_records (static medical profile per student)
-- One-to-many: a student may have multiple records over time, but typically one active.
-- ---------------------------------------------------------------------------
create table if not exists public.health_records (
  id                  uuid primary key default gen_random_uuid(),
  student_id          uuid not null references public.students(id) on delete cascade,
  blood_type          text check (blood_type in ('A+','A-','B+','B-','AB+','AB-','O+','O-','unknown')),
  height_cm           numeric(5,2),
  weight_kg           numeric(5,2),
  allergies           text,
  chronic_conditions  text,
  current_medications text,
  immunizations       text,             -- free-text; can normalize later
  emergency_contact   text,
  emergency_phone     text,
  physician_name      text,
  physician_phone     text,
  notes               text,
  recorded_at         timestamptz not null default now(),
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now(),
  deleted_at          timestamptz
);

create index if not exists health_records_student_idx on public.health_records (student_id);
create index if not exists health_records_recorded_at_idx on public.health_records (recorded_at desc);
create index if not exists health_records_deleted_at_idx on public.health_records (deleted_at);

drop trigger if exists trg_health_records_updated_at on public.health_records;
create trigger trg_health_records_updated_at
before update on public.health_records
for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- health_reports (per-visit / per-incident entries)
-- ---------------------------------------------------------------------------
create table if not exists public.health_reports (
  id            uuid primary key default gen_random_uuid(),
  student_id    uuid not null references public.students(id) on delete cascade,
  visit_date    timestamptz not null default now(),
  complaint     text,
  diagnosis     text,
  treatment     text,
  vitals_temp_c numeric(4,1),
  vitals_bp     text,                   -- e.g., '120/80'
  vitals_hr     int,
  notes         text,
  reported_by   text,                   -- name of nurse/staff (free-text until auth lands)
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),
  deleted_at    timestamptz
);

create index if not exists health_reports_student_idx on public.health_reports (student_id);
create index if not exists health_reports_visit_date_idx on public.health_reports (visit_date desc);
create index if not exists health_reports_deleted_at_idx on public.health_reports (deleted_at);

drop trigger if exists trg_health_reports_updated_at on public.health_reports;
create trigger trg_health_reports_updated_at
before update on public.health_reports
for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- report_files (attachments for health_reports — stored in 'health-files' bucket)
-- ---------------------------------------------------------------------------
create table if not exists public.report_files (
  id          uuid primary key default gen_random_uuid(),
  report_id   uuid not null references public.health_reports(id) on delete cascade,
  storage_path text not null,           -- path within the 'health-files' bucket
  file_name   text not null,
  mime_type   text,
  size_bytes  bigint,
  created_at  timestamptz not null default now()
);

create index if not exists report_files_report_idx on public.report_files (report_id);

-- ---------------------------------------------------------------------------
-- RLS — enabled, permissive policies (tighten when auth is added)
-- ---------------------------------------------------------------------------
alter table public.students        enable row level security;
alter table public.health_records  enable row level security;
alter table public.health_reports  enable row level security;
alter table public.report_files    enable row level security;

-- students
drop policy if exists "students all" on public.students;
create policy "students all" on public.students
  for all using (true) with check (true);

-- health_records
drop policy if exists "health_records all" on public.health_records;
create policy "health_records all" on public.health_records
  for all using (true) with check (true);

-- health_reports
drop policy if exists "health_reports all" on public.health_reports;
create policy "health_reports all" on public.health_reports
  for all using (true) with check (true);

-- report_files
drop policy if exists "report_files all" on public.report_files;
create policy "report_files all" on public.report_files
  for all using (true) with check (true);

-- ---------------------------------------------------------------------------
-- Storage bucket for attachments
-- Run in SQL editor; bucket creation via SQL is supported on Supabase.
-- ---------------------------------------------------------------------------
insert into storage.buckets (id, name, public)
values ('health-files', 'health-files', false)
on conflict (id) do nothing;

-- Permissive storage policies for the bucket (tighten with auth later).
drop policy if exists "health-files read" on storage.objects;
create policy "health-files read" on storage.objects
  for select using (bucket_id = 'health-files');

drop policy if exists "health-files write" on storage.objects;
create policy "health-files write" on storage.objects
  for insert with check (bucket_id = 'health-files');

drop policy if exists "health-files update" on storage.objects;
create policy "health-files update" on storage.objects
  for update using (bucket_id = 'health-files');

drop policy if exists "health-files delete" on storage.objects;
create policy "health-files delete" on storage.objects
  for delete using (bucket_id = 'health-files');
