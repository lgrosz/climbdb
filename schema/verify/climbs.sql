-- Verify climb-pg:climbs on pg

BEGIN;

SELECT id, name, description
    FROM climbs
    WHERE FALSE;

ROLLBACK;
