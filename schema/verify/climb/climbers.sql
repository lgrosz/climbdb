-- Verify climbdb:climb/climbers on pg

BEGIN;

SELECT id, slug, first_name, last_name
    FROM climb.climbers
    WHERE FALSE;

ROLLBACK;
