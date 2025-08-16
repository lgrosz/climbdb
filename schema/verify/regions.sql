-- Verify climbdb:regions on pg

BEGIN;

SELECT id, name
    FROM climb.regions
    WHERE FALSE;

ROLLBACK;
