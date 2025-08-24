-- Revert climbdb:topo/image-features from pg

BEGIN;

DROP TABLE topo.image_features;

COMMIT;
