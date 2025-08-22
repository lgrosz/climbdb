-- Revert climbdb:climb/crags from pg

BEGIN;

DROP TABLE climb.crags;

COMMIT;
