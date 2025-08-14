-- Revert climbdb:climbs from pg

BEGIN;

DROP TABLE climbs;

COMMIT;
