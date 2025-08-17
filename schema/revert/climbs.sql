-- Revert climbdb:climbs from pg

BEGIN;

DROP TABLE climb.climbs;

COMMIT;
