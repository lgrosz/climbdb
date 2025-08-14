-- Revert climbdb:climb-ext from pg

BEGIN;

DROP EXTENSION pg_climb;

COMMIT;
