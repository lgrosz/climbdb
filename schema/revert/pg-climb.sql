-- Revert climbdb:pg-climb from pg

BEGIN;

DROP EXTENSION pg_climb;

COMMIT;
