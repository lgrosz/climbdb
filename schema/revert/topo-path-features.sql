-- Revert climb-pg:topo-path-features from pg

BEGIN;

DROP TABLE topo_path_features;

COMMIT;
