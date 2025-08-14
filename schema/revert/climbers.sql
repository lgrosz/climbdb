-- Revert climbdb:climbers from pg

BEGIN;

DROP TABLE climbers;

COMMIT;
