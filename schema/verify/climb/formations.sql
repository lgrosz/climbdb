-- Verify climbdb:climb/formations on pg

BEGIN;

SELECT id, name, description, location, region_id, crag_id, sector_id
    FROM climb.formations
    WHERE FALSE;

ROLLBACK;
