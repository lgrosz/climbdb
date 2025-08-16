-- Revert climbdb:crags from pg

BEGIN;

DROP TABLE climb.crags;

COMMIT;
