-- Revert climbdb:topo from pg

BEGIN;

DROP SCHEMA topo;

COMMIT;
