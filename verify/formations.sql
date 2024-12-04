-- Verify climb-pg:formations on pg

BEGIN;

SELECT id, name, location, description
    FROM formations
    WHERE FALSE;

ROLLBACK;
