-- Revert climb-pg:postgis from pg

BEGIN;

DROP EXTENSION postgis;

COMMIT;
