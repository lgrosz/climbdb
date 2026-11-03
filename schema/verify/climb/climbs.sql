-- Verify climbdb:climb/climbs on pg

BEGIN;

SELECT id, slug, name, description, grade
    FROM climb.climbs
    WHERE FALSE;

ROLLBACK;
