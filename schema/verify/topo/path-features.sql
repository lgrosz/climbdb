-- Verify climbdb:topo.path-features on pg

BEGIN;

SELECT id, geometry, climb_id, topo_id
    FROM topo.path_features
    WHERE FALSE;

ROLLBACK;
