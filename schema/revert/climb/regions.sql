-- Revert climbdb:climb/regions from pg

BEGIN;

DROP TABLE climb.regions;

COMMIT;
