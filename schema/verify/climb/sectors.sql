-- Verify climbdb:climb/sectors on pg

BEGIN;

SELECT id, name
    FROM climb.sectors
    WHERE FALSE;

ROLLBACK;
