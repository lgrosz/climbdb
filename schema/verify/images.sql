-- Verify climbdb:images on pg

BEGIN;

SELECT id, alt
    FROM images
    WHERE FALSE;

ROLLBACK;
