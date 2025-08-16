-- Revert climbdb:regions from pg

BEGIN;

DROP TABLE climb.regions;

COMMIT;
