-- Revert climbdb:climb/formations from pg

BEGIN;

DROP TABLE climb.formations;

COMMIT;
