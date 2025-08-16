-- Verify climbdb:sectors on pg

BEGIN;

SELECT id, name
    FROM climb.sectors
    WHERE FALSE;

ROLLBACK;
