-- Revert climb-pg:appschema from pg

BEGIN;

DROP SCHEMA climb;

COMMIT;
