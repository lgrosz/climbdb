-- Verify climb-pg:images on pg

BEGIN;

SELECT id
    FROM images
    WHERE FALSE;

ROLLBACK;
