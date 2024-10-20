-- Verify climb-pg:climbs on pg

BEGIN;

SELECT id, name
    FROM climbs
    WHERE FALSE;

ROLLBACK;
