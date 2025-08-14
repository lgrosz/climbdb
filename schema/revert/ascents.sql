-- Revert climbdb:ascents from pg

BEGIN;

DROP TABLE ascents;

COMMIT;
