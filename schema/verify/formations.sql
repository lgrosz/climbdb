-- Verify climbdb:formations on pg

BEGIN;

SELECT id, name, description, location
    FROM climb.formations
    WHERE FALSE;

ROLLBACK;
