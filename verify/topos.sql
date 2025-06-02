-- Verify climb-pg:topos on pg

BEGIN;

SELECT id, title, width, height
    FROM topos
    WHERE FALSE;

ROLLBACK;
