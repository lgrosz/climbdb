-- Revert climbdb:topo-image-features from pg

BEGIN;

DROP TABLE topo_image_features;

COMMIT;
