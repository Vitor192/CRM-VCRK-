-- Execute no SQL Editor do Supabase para habilitar cidade, país e site nos contatos existentes.
alter table public.contacts
  add column if not exists city text not null default '',
  add column if not exists country text not null default '',
  add column if not exists website text not null default '';

create index if not exists contacts_user_country_city_idx
  on public.contacts (user_id, country, city);
