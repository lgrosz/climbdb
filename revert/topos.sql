-- Revert climb-pg:topos from pg

BEGIN;

DROP TABLE topos;

COMMIT;
