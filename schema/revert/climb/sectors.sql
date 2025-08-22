-- Revert climbdb:climb/sectors from pg

BEGIN;

DROP TABLE climb.sectors;

COMMIT;
