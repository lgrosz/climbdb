-- Revert climbdb:formations from pg

BEGIN;

DROP TABLE climb.formations;

COMMIT;
