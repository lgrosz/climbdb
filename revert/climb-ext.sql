-- Revert climb-pg:climb-ext from pg

BEGIN;

DROP EXTENSION pg_climb;

COMMIT;
