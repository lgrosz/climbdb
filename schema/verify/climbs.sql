-- Verify climbdb:climbs on pg

BEGIN;

SELECT id, name, description, region_id, crag_id, sector_id, formation_id
    FROM climb.climbs
    WHERE FALSE;

ROLLBACK;
