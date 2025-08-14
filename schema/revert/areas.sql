-- Revert climbdb:areas from pg

BEGIN;

DROP TABLE areas;

COMMIT;
