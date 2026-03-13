-- 1. Create the internal Supabase roles if they don't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'supabase_admin') THEN
        CREATE ROLE supabase_admin WITH LOGIN SUPERUSER CREATEROLE CREATEDB;
    END IF;

    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'anon') THEN
        CREATE ROLE anon NOLOGIN;
    END IF;

    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'authenticated') THEN
        CREATE ROLE authenticated NOLOGIN;
    END IF;

    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'service_role') THEN
        CREATE ROLE service_role WITH NOLOGIN CREATEROLE;
    END IF;
END $$;


CREATE SCHEMA IF NOT EXISTS offreg;

-- Role used by PostgREST to connect (LOGIN role)
CREATE ROLE authenticator WITH LOGIN PASSWORD 'NTgdO76M1a1ok2QDAh4WGnG3iOPgd4VG';
GRANT anon, authenticated TO authenticator;

GRANT USAGE ON SCHEMA public TO anon, authenticated;
GRANT USAGE ON SCHEMA offreg TO anon, authenticated;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO anon, authenticated;
GRANT SELECT ON ALL TABLES IN SCHEMA offreg TO anon, authenticated;

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO anon, authenticated;
ALTER DEFAULT PRIVILEGES IN SCHEMA offreg GRANT SELECT ON TABLES TO anon, authenticated;

-- Update search paths so extension types can be used bare
CREATE SCHEMA IF NOT EXISTS extensions;
ALTER DATABASE postgres SET search_path TO "$user", public, extensions;

-- Pre-add pgaudit to avoid migration error
CREATE EXTENSION IF NOT EXISTS "pgaudit" WITH SCHEMA "public"; -- Note no version
