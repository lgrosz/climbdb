-- Verify climbdb:climb/crags on pg

BEGIN;

SELECT id, slug, name, description, region_id
    FROM climb.crags
    WHERE FALSE;

ROLLBACK;
