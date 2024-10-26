-- Revert climb-pg:climb-closures from pg

BEGIN;

DROP TABLE climb_closures;

COMMIT;
