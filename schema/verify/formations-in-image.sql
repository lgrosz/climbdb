-- Verify climbdb:formations-in-images on pg

BEGIN;

SELECT image_id, formation_id
    FROM formations_in_image
    WHERE FALSE;

ROLLBACK;
