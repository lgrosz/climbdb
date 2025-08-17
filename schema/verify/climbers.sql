-- Verify climbdb:climbers on pg

BEGIN;

SELECT id, first_name, last_name
    FROM climb.climbers
    WHERE FALSE;

ROLLBACK;
