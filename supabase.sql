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

-- Um contato pode ter vários registros de atendimento, cada um com observação e retorno.
create table if not exists public.contact_attendances (
  id uuid primary key default gen_random_uuid(),
  contact_id uuid not null references public.contacts(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade default auth.uid(),
  reason text not null check (char_length(reason) between 1 and 300),
  observation text not null default '',
  return_at timestamptz,
  created_at timestamptz not null default now()
);
create index if not exists contact_attendances_contact_created_idx
  on public.contact_attendances (contact_id, created_at desc);
alter table public.contact_attendances enable row level security;
drop policy if exists "Users can view own contact attendances" on public.contact_attendances;
create policy "Users can view own contact attendances" on public.contact_attendances
  for select to authenticated
  using ((select auth.uid()) = user_id and exists (
    select 1 from public.contacts c where c.id = contact_id and c.user_id = (select auth.uid())
  ));
drop policy if exists "Users can add own contact attendances" on public.contact_attendances;
create policy "Users can add own contact attendances" on public.contact_attendances
  for insert to authenticated
  with check ((select auth.uid()) = user_id and exists (
    select 1 from public.contacts c where c.id = contact_id and c.user_id = (select auth.uid())
  ));
drop policy if exists "Users can delete own contact attendances" on public.contact_attendances;
create policy "Users can delete own contact attendances" on public.contact_attendances
  for delete to authenticated
  using ((select auth.uid()) = user_id and exists (
    select 1 from public.contacts c where c.id = contact_id and c.user_id = (select auth.uid())
  ));
