-- MA CAISSE : installation/mise à jour Supabase
-- À exécuter dans Supabase > SQL Editor.

-- 1) OPERATIONS : suppression durable des historiques
alter table public.operations enable row level security;
alter table public.operations add column if not exists local_id text;
update public.operations set local_id=id::text where local_id is null;
create index if not exists operations_local_id_idx on public.operations(local_id);
drop policy if exists "operations_select_own" on public.operations;
create policy "operations_select_own" on public.operations for select to authenticated using (auth.uid()=user_id);
drop policy if exists "operations_insert_own" on public.operations;
create policy "operations_insert_own" on public.operations for insert to authenticated with check (auth.uid()=user_id);
drop policy if exists "operations_delete_own" on public.operations;
create policy "operations_delete_own" on public.operations for delete to authenticated using (auth.uid()=user_id);

-- 2) AUTRES ACTIVITES
alter table public.autres_activites enable row level security;
drop policy if exists "activities_select_own" on public.autres_activites;
create policy "activities_select_own" on public.autres_activites for select to authenticated using (auth.uid()=user_id);
drop policy if exists "activities_insert_own" on public.autres_activites;
create policy "activities_insert_own" on public.autres_activites for insert to authenticated with check (auth.uid()=user_id);

-- 3) DETTES + signatures
create table if not exists public.dettes (
 id text primary key,
 user_id uuid not null references auth.users(id) on delete cascade,
 reseau text not null,
 client text not null,
 montant numeric not null check (montant>0),
 observation text,
 created_at timestamptz not null default now(),
 paid boolean not null default false,
 paid_at timestamptz,
 signature_debt text,
 payment_signature text
);
alter table public.dettes add column if not exists signature_debt text;
alter table public.dettes add column if not exists payment_signature text;
alter table public.dettes enable row level security;
drop policy if exists "dettes_select_own" on public.dettes;
create policy "dettes_select_own" on public.dettes for select to authenticated using (auth.uid()=user_id);
drop policy if exists "dettes_insert_own" on public.dettes;
create policy "dettes_insert_own" on public.dettes for insert to authenticated with check (auth.uid()=user_id);
drop policy if exists "dettes_update_own" on public.dettes;
create policy "dettes_update_own" on public.dettes for update to authenticated using (auth.uid()=user_id) with check (auth.uid()=user_id);
drop policy if exists "dettes_delete_own" on public.dettes;
create policy "dettes_delete_own" on public.dettes for delete to authenticated using (auth.uid()=user_id);
grant select,insert,update,delete on public.dettes to authenticated;

-- 4) PHOTO DE PROFIL
create table if not exists public.user_profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 photo_path text,
 updated_at timestamptz not null default now()
);
alter table public.user_profiles enable row level security;
drop policy if exists "profiles_select_own" on public.user_profiles;
create policy "profiles_select_own" on public.user_profiles for select to authenticated using (auth.uid()=id);
drop policy if exists "profiles_insert_own" on public.user_profiles;
create policy "profiles_insert_own" on public.user_profiles for insert to authenticated with check (auth.uid()=id);
drop policy if exists "profiles_update_own" on public.user_profiles;
create policy "profiles_update_own" on public.user_profiles for update to authenticated using (auth.uid()=id) with check (auth.uid()=id);

do $$ begin
 if not exists(select 1 from storage.buckets where id='profile-photos') then
  insert into storage.buckets(id,name,public) values('profile-photos','profile-photos',false);
 end if;
 if not exists(select 1 from storage.buckets where id='security-captures') then
  insert into storage.buckets(id,name,public) values('security-captures','security-captures',false);
 end if;
end $$;

-- 5) Règles stockage photos de profil
drop policy if exists "profile_upload_own" on storage.objects;
create policy "profile_upload_own" on storage.objects for insert to authenticated with check (bucket_id='profile-photos' and (storage.foldername(name))[1]=auth.uid()::text);
drop policy if exists "profile_select_own" on storage.objects;
create policy "profile_select_own" on storage.objects for select to authenticated using (bucket_id='profile-photos' and (storage.foldername(name))[1]=auth.uid()::text);
drop policy if exists "profile_update_own" on storage.objects;
create policy "profile_update_own" on storage.objects for update to authenticated using (bucket_id='profile-photos' and (storage.foldername(name))[1]=auth.uid()::text) with check (bucket_id='profile-photos' and (storage.foldername(name))[1]=auth.uid()::text);
drop policy if exists "profile_delete_own" on storage.objects;
create policy "profile_delete_own" on storage.objects for delete to authenticated using (bucket_id='profile-photos' and (storage.foldername(name))[1]=auth.uid()::text);

-- 6) CAPTURES CAMERA APRES 3 ECHECS
create table if not exists public.security_captures (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 file_path text not null,
 created_at timestamptz not null default now()
);
alter table public.security_captures enable row level security;
drop policy if exists "security_select_own" on public.security_captures;
create policy "security_select_own" on public.security_captures for select to authenticated using (auth.uid()=user_id);
drop policy if exists "security_insert_own" on public.security_captures;
create policy "security_insert_own" on public.security_captures for insert to authenticated with check (auth.uid()=user_id);
drop policy if exists "security_delete_own" on public.security_captures;
create policy "security_delete_own" on public.security_captures for delete to authenticated using (auth.uid()=user_id);

drop policy if exists "security_upload_own" on storage.objects;
create policy "security_upload_own" on storage.objects for insert to authenticated with check (bucket_id='security-captures' and (storage.foldername(name))[1]=auth.uid()::text);
drop policy if exists "security_read_own" on storage.objects;
create policy "security_read_own" on storage.objects for select to authenticated using (bucket_id='security-captures' and (storage.foldername(name))[1]=auth.uid()::text);
drop policy if exists "security_delete_own" on storage.objects;
create policy "security_delete_own" on storage.objects for delete to authenticated using (bucket_id='security-captures' and (storage.foldername(name))[1]=auth.uid()::text);

-- 7) DEPENSES PERSONNELLES
-- Les dépenses personnelles sont séparées des opérations commerciales.
create table if not exists public.depenses_personnelles (
 id text primary key,
 user_id uuid not null references auth.users(id) on delete cascade,
 categorie text not null,
 montant numeric not null check (montant>0),
 observation text,
 created_at timestamptz not null default now()
);
alter table public.depenses_personnelles enable row level security;
drop policy if exists "personal_expenses_select_own" on public.depenses_personnelles;
create policy "personal_expenses_select_own" on public.depenses_personnelles for select to authenticated using (auth.uid()=user_id);
drop policy if exists "personal_expenses_insert_own" on public.depenses_personnelles;
create policy "personal_expenses_insert_own" on public.depenses_personnelles for insert to authenticated with check (auth.uid()=user_id);
drop policy if exists "personal_expenses_delete_own" on public.depenses_personnelles;
create policy "personal_expenses_delete_own" on public.depenses_personnelles for delete to authenticated using (auth.uid()=user_id);
grant select,insert,delete on public.depenses_personnelles to authenticated;
