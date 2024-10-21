-- Verify climb-pg:formations on pg

BEGIN;

SELECT id, name, location
    FROM formations
    WHERE FALSE;

ROLLBACK;
