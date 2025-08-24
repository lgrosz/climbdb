-- Verify climbdb:topo/topos on pg

BEGIN;

SELECT id, title, width, height
    FROM topo.topos
    WHERE FALSE;

ROLLBACK;
