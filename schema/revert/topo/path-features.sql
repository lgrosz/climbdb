-- Revert climbdb:topo/path-features from pg

BEGIN;

DROP TABLE topo.path_features;

COMMIT;
