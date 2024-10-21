-- Verify climb-pg:areas on pg

BEGIN;

SELECT id, name
    FROM areas
    WHERE FALSE;

ROLLBACK;
