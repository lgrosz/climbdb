-- Verify climbdb:climb/formations-in-images on pg

BEGIN;

SELECT image_id, formation_id
    FROM climb.formations_in_image
    WHERE FALSE;

ROLLBACK;
