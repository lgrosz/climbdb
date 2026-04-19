-- Verify climbdb:climb/regions on pg

BEGIN;

SELECT id, slug, name, description
    FROM climb.regions
    WHERE FALSE;

ROLLBACK;
