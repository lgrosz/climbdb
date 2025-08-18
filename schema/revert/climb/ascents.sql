-- Revert climbdb:climb/ascents from pg

BEGIN;

DROP TABLE climb.ascents;

COMMIT;
