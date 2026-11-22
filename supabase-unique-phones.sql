-- Impede novos contatos com telefone repetido dentro da mesma conta.
-- Telefones são comparados só com dígitos; o prefixo 55 é ignorado em números brasileiros.

create or replace function public.normalize_contact_phone(raw_phone text)
returns text
language sql
immutable
parallel safe
set search_path = pg_catalog
as $$
  with digits as (
    select regexp_replace(coalesce(raw_phone, ''), '[^0-9]', '', 'g') as value
  )
  select case
    when value ~ '^55[0-9]{10,11}$' then substr(value, 3)
    else value
  end
  from digits;
$$;

create index if not exists contacts_user_phone_normalized_idx
  on public.contacts (user_id, public.normalize_contact_phone(phone))
  where public.normalize_contact_phone(phone) <> '';

create or replace function public.prevent_duplicate_contact_phone()
returns trigger
language plpgsql
security invoker
set search_path = public, pg_temp
as $$
declare
  normalized_phone text;
begin
  normalized_phone := public.normalize_contact_phone(new.phone);
  if normalized_phone = '' then
    return new;
  end if;

  perform pg_advisory_xact_lock(
    hashtextextended(new.user_id::text || ':' || normalized_phone, 0)
  );

  if exists (
    select 1
    from public.contacts existing
    where existing.user_id = new.user_id
      and existing.id <> new.id
      and public.normalize_contact_phone(existing.phone) = normalized_phone
  ) then
    raise exception 'Este telefone já está cadastrado em outro contato.'
      using errcode = '23505';
  end if;

  return new;
end;
$$;

create or replace trigger contacts_prevent_duplicate_phone
before insert or update of phone, user_id on public.contacts
for each row execute function public.prevent_duplicate_contact_phone();
