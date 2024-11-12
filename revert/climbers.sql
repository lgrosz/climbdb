-- Revert climb-pg:climbers from pg

BEGIN;

DROP TABLE climbers;

COMMIT;
