-- Verify climb-pg:topos on pg

BEGIN;

SELECT id, image_id, crop
    FROM topos
    WHERE FALSE;

ROLLBACK;
