-- Verify climbdb:climb/formations on pg

BEGIN;

-- climb/areas later merges this table into climb.areas
DO $$
BEGIN
    IF to_regclass('climb.areas') IS NULL THEN
        PERFORM id, slug, name, description, geom, region_id, crag_id, sector_id
            FROM climb.formations
            WHERE FALSE;
    END IF;
END
$$;

ROLLBACK;
