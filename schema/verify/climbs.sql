-- Verify climbdb:climbs on pg

BEGIN;

SELECT id, name, description
    FROM climb.climbs
    WHERE FALSE;

ROLLBACK;
