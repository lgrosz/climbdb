-- Revert climbdb:appschema from pg

BEGIN;

DROP SCHEMA climb;

COMMIT;
