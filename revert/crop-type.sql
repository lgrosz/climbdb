-- Revert climb-pg:crop-type from pg

BEGIN;

DROP TYPE crop;

COMMIT;
