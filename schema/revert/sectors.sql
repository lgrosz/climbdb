-- Revert climbdb:sectors from pg

BEGIN;

DROP TABLE climb.sectors;

COMMIT;
