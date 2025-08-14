-- Revert climb-pg:topo-image-features from pg

BEGIN;

DROP TABLE topo_image_features;

COMMIT;
