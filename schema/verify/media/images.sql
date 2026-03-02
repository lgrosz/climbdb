-- Verify climbdb:media/images on pg

BEGIN;

SELECT id, alt, object_key
    FROM media.images
    WHERE FALSE;

ROLLBACK;
