create extension if not exists "pg_cron" with schema "extensions";



grant usage on schema cron to service_role, postgres, anon;
grant all privileges on all tables in schema cron to service_role, postgres, anon;


create extension if not exists pg_net with schema "extensions";