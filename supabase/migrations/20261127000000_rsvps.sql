-- Confirmaciones de asistencia del cumple de Joaco
create table if not exists public.rsvps (
  guest_key   text primary key,
  guest_name  text not null check (char_length(guest_name) <= 60),
  respuesta   text not null check (respuesta in ('yes', 'late', 'one', 'no')),
  quien       text check (quien is null or char_length(quien) <= 40),
  updated_at  timestamptz not null default now(),
  -- Solo se aceptan las cartas que existen en la invitación
  constraint rsvps_guest_key_valid check (guest_key in (
    'nati', 'jota', 'martin-y-ro', 'velo', 'nanu', 'coti', 'charo', 'chule',
    'martu-y-nico', 'toto', 'gaston', 'more', 'fiore'
  ))
);

-- Mantener updated_at al día cuando alguien cambia su respuesta
create or replace function public.rsvps_touch() returns trigger
language plpgsql set search_path = '' as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists rsvps_touch on public.rsvps;
create trigger rsvps_touch before update on public.rsvps
for each row execute function public.rsvps_touch();

-- Seguridad: cualquiera con el link puede ver, confirmar y cambiar su respuesta.
-- Nadie puede borrar desde la página.
alter table public.rsvps enable row level security;

revoke all on public.rsvps from anon, authenticated;
grant select, insert, update on public.rsvps to anon;

drop policy if exists "rsvps_select" on public.rsvps;
create policy "rsvps_select" on public.rsvps for select to anon using (true);

drop policy if exists "rsvps_insert" on public.rsvps;
create policy "rsvps_insert" on public.rsvps for insert to anon with check (true);

drop policy if exists "rsvps_update" on public.rsvps;
create policy "rsvps_update" on public.rsvps for update to anon using (true) with check (true);
