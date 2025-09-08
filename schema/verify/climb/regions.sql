-- Verify climbdb:climb/regions on pg

BEGIN;

SELECT id, name, description
    FROM climb.regions
    WHERE FALSE;

ROLLBACK;
