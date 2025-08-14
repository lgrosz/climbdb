-- Revert climb-pg:ascents from pg

BEGIN;

DROP TABLE ascents;

COMMIT;
