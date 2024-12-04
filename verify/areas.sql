-- Verify climb-pg:areas on pg

BEGIN;

SELECT id, name, description
    FROM areas
    WHERE FALSE;

ROLLBACK;
