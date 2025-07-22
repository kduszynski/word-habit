-- Migration: Initial Schema Setup
-- Description: Creates the initial database schema for Word Habit application
-- Tables: translations, user_settings, notification_history, translation_generation_logs, translation_generation_error_logs
-- Author: AI Assistant
-- Date: 2024-07-22

-- Enable required extensions
create extension if not exists "pg_trgm";

-- Create custom types
do $$
begin
  if not exists (select 1 from pg_type where typname = 'translation_source') then
    create type translation_source as enum ('MANUAL', 'AI_GENERATED', 'AI_MODIFIED');
  end if;
end
$$;

-- translations table
create table if not exists translations (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) not null,
  original_text varchar(500) not null,
  basic_translation varchar(1000) not null,
  secondary_translations jsonb,
  examples jsonb,
  part_of_speech varchar(100),
  original_language char(2) not null,
  target_language char(2) not null,
  is_known boolean not null default false,
  translation_source translation_source not null,
  generation_log_id uuid,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id, original_text, original_language, target_language)
);

comment on table translations is 'Stores user translations with their metadata';

-- user_settings table
create table if not exists user_settings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) not null,
  send_time time without time zone not null,
  monday boolean not null default true,
  tuesday boolean not null default true,
  wednesday boolean not null default true,
  thursday boolean not null default true,
  friday boolean not null default true,
  saturday boolean not null default true,
  sunday boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id)
);

comment on table user_settings is 'Stores user notification preferences';

-- translation_generation_logs table
create table if not exists translation_generation_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) not null,
  model_name varchar(100) not null,
  input_payload jsonb not null,
  response_payload jsonb not null,
  request_timestamp timestamptz not null default now(),
  duration_ms int not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table translation_generation_logs is 'Logs successful AI translation generation attempts';

-- Add foreign key constraint after creating translation_generation_logs
alter table translations
  add constraint translations_generation_log_id_fkey
  foreign key (generation_log_id)
  references translation_generation_logs(id)
  on delete set null;

-- translation_generation_error_logs table
create table if not exists translation_generation_error_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) not null,
  error_code varchar(100) not null,
  error_message text not null,
  request_payload jsonb not null,
  response_payload jsonb not null,
  error_timestamp timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table translation_generation_error_logs is 'Logs failed AI translation generation attempts';

-- notification_history table
create table if not exists notification_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) not null,
  translation_id uuid references translations(id) not null,
  sent_at timestamptz not null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table notification_history is 'Tracks sent notifications to users';

-- Create indexes
create index if not exists idx_translations_user_id on translations(user_id);
create index if not exists idx_translations_secondary_translations on translations using gin(secondary_translations);
create index if not exists idx_translations_examples on translations using gin(examples);
create index if not exists idx_translations_original_text on translations using gin(original_text gin_trgm_ops);
create index if not exists idx_translations_basic_translation on translations using gin(basic_translation gin_trgm_ops);

create index if not exists idx_notification_history_user_id on notification_history(user_id);
create index if not exists idx_notification_history_translation_id on notification_history(translation_id);

create index if not exists idx_translation_generation_logs_user_id on translation_generation_logs(user_id);
create index if not exists idx_translation_generation_logs_request_timestamp on translation_generation_logs(request_timestamp);

create index if not exists idx_translation_generation_error_logs_user_id on translation_generation_error_logs(user_id);
create index if not exists idx_translation_generation_error_logs_error_timestamp on translation_generation_error_logs(error_timestamp);

-- Create triggers for updated_at timestamps
create or replace function update_updated_at_column()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger update_translations_updated_at
  before update on translations
  for each row
  execute function update_updated_at_column();

create trigger update_user_settings_updated_at
  before update on user_settings
  for each row
  execute function update_updated_at_column();

create trigger update_notification_history_updated_at
  before update on notification_history
  for each row
  execute function update_updated_at_column();

create trigger update_translation_generation_logs_updated_at
  before update on translation_generation_logs
  for each row
  execute function update_updated_at_column();

create trigger update_translation_generation_error_logs_updated_at
  before update on translation_generation_error_logs
  for each row
  execute function update_updated_at_column(); 