-- Verify climb-pg:topo-path-features on pg

BEGIN;

SELECT id, geometry, climb_id, topo_id
    FROM topo_path_features
    WHERE FALSE;

ROLLBACK;
