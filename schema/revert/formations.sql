-- Revert climbdb:formations from pg

BEGIN;

DROP TABLE formations;

COMMIT;
