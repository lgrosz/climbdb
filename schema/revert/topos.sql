-- Revert climbdb:topos from pg

BEGIN;

DROP TABLE topos;

COMMIT;
