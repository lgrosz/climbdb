-- Verify climb-pg:climb-topo-splines on pg

BEGIN;

SELECT topo_id, climb_id, splines
    FROM climb_topo_splines
    WHERE FALSE;

ROLLBACK;
