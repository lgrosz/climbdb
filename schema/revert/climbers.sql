-- Revert climbdb:climbers from pg

BEGIN;

DROP TABLE climb.climbers;

COMMIT;
