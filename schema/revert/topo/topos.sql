-- Revert climbdb:topo/topos from pg

BEGIN;

DROP TABLE topo.topos;

COMMIT;
