-- Execute este script no SQL Editor do seu projeto Supabase.
create table if not exists public.contacts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade default auth.uid(),
  name text not null check (char_length(name) between 1 and 120),
  phone text not null default '',
  reason text not null default '',
  source text not null default '',
  return_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists contacts_user_return_idx on public.contacts (user_id, return_at);
alter table public.contacts enable row level security;
drop policy if exists "Users can view own contacts" on public.contacts;
create policy "Users can view own contacts" on public.contacts for select to authenticated using ((select auth.uid()) = user_id);
drop policy if exists "Users can add own contacts" on public.contacts;
create policy "Users can add own contacts" on public.contacts for insert to authenticated with check ((select auth.uid()) = user_id);
drop policy if exists "Users can edit own contacts" on public.contacts;
create policy "Users can edit own contacts" on public.contacts for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
drop policy if exists "Users can delete own contacts" on public.contacts;
create policy "Users can delete own contacts" on public.contacts for delete to authenticated using ((select auth.uid()) = user_id);
