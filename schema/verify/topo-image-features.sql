-- Verify climbdb:topo-image-features on pg

BEGIN;

SELECT id, source_crop, dest_crop, image_id, topo_id
    FROM topo_image_features
    WHERE FALSE;

ROLLBACK;
