-- Revert climb-pg:formations from pg

BEGIN;

DROP TABLE formations;

COMMIT;
