-- Revert climbdb:climb from pg

BEGIN;

DROP SCHEMA climb;

COMMIT;
