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
