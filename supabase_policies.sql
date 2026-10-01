-- À exécuter dans Supabase > SQL Editor.
-- Ces règles autorisent chaque utilisateur connecté (y compris anonyme) à lire/écrire uniquement ses propres lignes.

alter table public.operations enable row level security;
alter table public.autres_activites enable row level security;

drop policy if exists "operations_select_own" on public.operations;
create policy "operations_select_own" on public.operations
for select to authenticated using (auth.uid() = user_id);

drop policy if exists "operations_insert_own" on public.operations;
create policy "operations_insert_own" on public.operations
for insert to authenticated with check (auth.uid() = user_id);

drop policy if exists "activities_select_own" on public.autres_activites;
create policy "activities_select_own" on public.autres_activites
for select to authenticated using (auth.uid() = user_id);

drop policy if exists "activities_insert_own" on public.autres_activites;
create policy "activities_insert_own" on public.autres_activites
for insert to authenticated with check (auth.uid() = user_id);


-- Table des dettes de Ma Caisse
create table if not exists public.dettes (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  reseau text not null,
  client text not null,
  montant numeric not null check (montant > 0),
  observation text,
  created_at timestamptz not null default now(),
  paid boolean not null default false,
  paid_at timestamptz
);

alter table public.dettes enable row level security;

drop policy if exists "dettes_select_own" on public.dettes;
create policy "dettes_select_own" on public.dettes
for select to authenticated using (auth.uid() = user_id);

drop policy if exists "dettes_insert_own" on public.dettes;
create policy "dettes_insert_own" on public.dettes
for insert to authenticated with check (auth.uid() = user_id);

drop policy if exists "dettes_update_own" on public.dettes;
create policy "dettes_update_own" on public.dettes
for update to authenticated using (auth.uid() = user_id)
with check (auth.uid() = user_id);

grant select, insert, update on public.dettes to authenticated;
