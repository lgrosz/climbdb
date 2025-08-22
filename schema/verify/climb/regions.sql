-- Verify climbdb:climb/regions on pg

BEGIN;

SELECT id, name
    FROM climb.regions
    WHERE FALSE;

ROLLBACK;
