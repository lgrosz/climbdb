-- Revert climb-pg:climbs from pg

BEGIN;

DROP TABLE climbs;

COMMIT;
