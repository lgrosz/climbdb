-- Verify climbdb:climb/formations on pg

BEGIN;

SELECT id, slug, name, description, geom, region_id, crag_id, sector_id
    FROM climb.formations
    WHERE FALSE;

ROLLBACK;
