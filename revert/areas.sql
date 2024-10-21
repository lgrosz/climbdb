-- Revert climb-pg:areas from pg

BEGIN;

DROP TABLE areas;

COMMIT;
