-- Revert climb-pg:climb-topo-splines from pg

BEGIN;

DROP TABLE climb_topo_splines;

COMMIT;
