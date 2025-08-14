-- Revert climbdb:postgis from pg

BEGIN;

DROP EXTENSION postgis;

COMMIT;
