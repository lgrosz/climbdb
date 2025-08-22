-- Revert climbdb:climb/climbs from pg

BEGIN;

DROP TABLE climb.climbs;

COMMIT;
