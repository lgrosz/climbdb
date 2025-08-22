-- Verify climbdb:media/images on pg

BEGIN;

SELECT id, alt
    FROM media.images
    WHERE FALSE;

ROLLBACK;
