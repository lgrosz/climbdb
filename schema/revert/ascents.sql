-- Revert climbdb:ascents from pg

BEGIN;

DROP TABLE climb.ascents;

COMMIT;
