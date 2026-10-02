-- MA CAISSE : SQL COMPLET SUPABASE
-- À exécuter une seule fois dans Supabase > SQL Editor.
-- L'application utilise l'authentification anonyme Supabase.

-- =========================
-- OPERATIONS
-- =========================
ALTER TABLE public.operations ADD COLUMN IF NOT EXISTS local_id text;
UPDATE public.operations SET local_id=id::text WHERE local_id IS NULL;
CREATE INDEX IF NOT EXISTS operations_local_id_idx ON public.operations(local_id);
ALTER TABLE public.operations ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "operations_select_own" ON public.operations;
CREATE POLICY "operations_select_own" ON public.operations FOR SELECT TO authenticated USING (auth.uid()=user_id);
DROP POLICY IF EXISTS "operations_insert_own" ON public.operations;
CREATE POLICY "operations_insert_own" ON public.operations FOR INSERT TO authenticated WITH CHECK (auth.uid()=user_id);
DROP POLICY IF EXISTS "operations_update_own" ON public.operations;
CREATE POLICY "operations_update_own" ON public.operations FOR UPDATE TO authenticated USING (auth.uid()=user_id) WITH CHECK (auth.uid()=user_id);
DROP POLICY IF EXISTS "operations_delete_own" ON public.operations;
CREATE POLICY "operations_delete_own" ON public.operations FOR DELETE TO authenticated USING (auth.uid()=user_id);
GRANT SELECT,INSERT,UPDATE,DELETE ON public.operations TO authenticated;

-- =========================
-- AUTRES ACTIVITES
-- =========================
ALTER TABLE public.autres_activites ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "activities_select_own" ON public.autres_activites;
CREATE POLICY "activities_select_own" ON public.autres_activites FOR SELECT TO authenticated USING (auth.uid()=user_id);
DROP POLICY IF EXISTS "activities_insert_own" ON public.autres_activites;
CREATE POLICY "activities_insert_own" ON public.autres_activites FOR INSERT TO authenticated WITH CHECK (auth.uid()=user_id);
DROP POLICY IF EXISTS "activities_delete_own" ON public.autres_activites;
CREATE POLICY "activities_delete_own" ON public.autres_activites FOR DELETE TO authenticated USING (auth.uid()=user_id);
GRANT SELECT,INSERT,DELETE ON public.autres_activites TO authenticated;

-- =========================
-- DETTES + SIGNATURES
-- =========================
CREATE TABLE IF NOT EXISTS public.dettes (
  id text PRIMARY KEY,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  reseau text NOT NULL,
  client text NOT NULL,
  montant numeric NOT NULL CHECK (montant>0),
  observation text,
  created_at timestamptz NOT NULL DEFAULT now(),
  paid boolean NOT NULL DEFAULT false,
  paid_at timestamptz,
  signature_debt text,
  payment_signature text
);
ALTER TABLE public.dettes ADD COLUMN IF NOT EXISTS signature_debt text;
ALTER TABLE public.dettes ADD COLUMN IF NOT EXISTS payment_signature text;
ALTER TABLE public.dettes ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "dettes_select_own" ON public.dettes;
CREATE POLICY "dettes_select_own" ON public.dettes FOR SELECT TO authenticated USING (auth.uid()=user_id);
DROP POLICY IF EXISTS "dettes_insert_own" ON public.dettes;
CREATE POLICY "dettes_insert_own" ON public.dettes FOR INSERT TO authenticated WITH CHECK (auth.uid()=user_id);
DROP POLICY IF EXISTS "dettes_update_own" ON public.dettes;
CREATE POLICY "dettes_update_own" ON public.dettes FOR UPDATE TO authenticated USING (auth.uid()=user_id) WITH CHECK (auth.uid()=user_id);
DROP POLICY IF EXISTS "dettes_delete_own" ON public.dettes;
CREATE POLICY "dettes_delete_own" ON public.dettes FOR DELETE TO authenticated USING (auth.uid()=user_id);
GRANT SELECT,INSERT,UPDATE,DELETE ON public.dettes TO authenticated;

-- =========================
-- CAPTURES DE SECURITE
-- =========================
CREATE TABLE IF NOT EXISTS public.security_captures (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid(),
  file_path text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.security_captures ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "security_captures_select_own" ON public.security_captures;
CREATE POLICY "security_captures_select_own" ON public.security_captures FOR SELECT TO authenticated USING (auth.uid()=user_id);
DROP POLICY IF EXISTS "security_captures_insert_own" ON public.security_captures;
CREATE POLICY "security_captures_insert_own" ON public.security_captures FOR INSERT TO authenticated WITH CHECK (auth.uid()=user_id);
DROP POLICY IF EXISTS "security_captures_delete_own" ON public.security_captures;
CREATE POLICY "security_captures_delete_own" ON public.security_captures FOR DELETE TO authenticated USING (auth.uid()=user_id);
GRANT SELECT,INSERT,DELETE ON public.security_captures TO authenticated;

INSERT INTO storage.buckets(id,name,public) VALUES('security-captures','security-captures',false) ON CONFLICT(id) DO NOTHING;
DROP POLICY IF EXISTS "security_capture_upload_own" ON storage.objects;
CREATE POLICY "security_capture_upload_own" ON storage.objects FOR INSERT TO authenticated WITH CHECK(bucket_id='security-captures' AND (storage.foldername(name))[1]=auth.uid()::text);
DROP POLICY IF EXISTS "security_capture_read_own" ON storage.objects;
CREATE POLICY "security_capture_read_own" ON storage.objects FOR SELECT TO authenticated USING(bucket_id='security-captures' AND (storage.foldername(name))[1]=auth.uid()::text);
DROP POLICY IF EXISTS "security_capture_delete_own" ON storage.objects;
CREATE POLICY "security_capture_delete_own" ON storage.objects FOR DELETE TO authenticated USING(bucket_id='security-captures' AND (storage.foldername(name))[1]=auth.uid()::text);

-- =========================
-- PHOTO DE PROFIL
-- =========================
CREATE TABLE IF NOT EXISTS public.profiles (
  user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  photo_path text,
  updated_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "profiles_select_own" ON public.profiles;
CREATE POLICY "profiles_select_own" ON public.profiles FOR SELECT TO authenticated USING(auth.uid()=user_id);
DROP POLICY IF EXISTS "profiles_insert_own" ON public.profiles;
CREATE POLICY "profiles_insert_own" ON public.profiles FOR INSERT TO authenticated WITH CHECK(auth.uid()=user_id);
DROP POLICY IF EXISTS "profiles_update_own" ON public.profiles;
CREATE POLICY "profiles_update_own" ON public.profiles FOR UPDATE TO authenticated USING(auth.uid()=user_id) WITH CHECK(auth.uid()=user_id);
GRANT SELECT,INSERT,UPDATE ON public.profiles TO authenticated;

INSERT INTO storage.buckets(id,name,public) VALUES('profile-photos','profile-photos',false) ON CONFLICT(id) DO NOTHING;
DROP POLICY IF EXISTS "profile_photo_upload_own" ON storage.objects;
CREATE POLICY "profile_photo_upload_own" ON storage.objects FOR INSERT TO authenticated WITH CHECK(bucket_id='profile-photos' AND (storage.foldername(name))[1]=auth.uid()::text);
DROP POLICY IF EXISTS "profile_photo_update_own" ON storage.objects;
CREATE POLICY "profile_photo_update_own" ON storage.objects FOR UPDATE TO authenticated USING(bucket_id='profile-photos' AND (storage.foldername(name))[1]=auth.uid()::text) WITH CHECK(bucket_id='profile-photos' AND (storage.foldername(name))[1]=auth.uid()::text);
DROP POLICY IF EXISTS "profile_photo_read_own" ON storage.objects;
CREATE POLICY "profile_photo_read_own" ON storage.objects FOR SELECT TO authenticated USING(bucket_id='profile-photos' AND (storage.foldername(name))[1]=auth.uid()::text);
