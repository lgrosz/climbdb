-- Verify climbdb:climbs on pg

BEGIN;

SELECT id, name, description
    FROM climbs
    WHERE FALSE;

ROLLBACK;
