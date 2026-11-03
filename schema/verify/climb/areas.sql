-- Verify climbdb:climb/areas on pg

BEGIN;

SELECT id, parent_id, slug, name, description, geom
    FROM climb.areas
    WHERE FALSE;

SELECT area_id
    FROM climb.climbs
    WHERE FALSE;

SELECT pg_catalog.has_function_privilege('climb.areas_prevent_cycle()', 'execute');

DO $$
BEGIN
    IF to_regclass('climb.regions') IS NOT NULL
        OR to_regclass('climb.crags') IS NOT NULL
        OR to_regclass('climb.sectors') IS NOT NULL
        OR to_regclass('climb.formations') IS NOT NULL
    THEN
        RAISE EXCEPTION 'regions, crags, sectors, and formations should have been dropped';
    END IF;

    IF EXISTS (
        SELECT FROM pg_attribute
        WHERE attrelid = 'climb.climbs'::regclass
          AND attname IN ('region_id', 'crag_id', 'sector_id', 'formation_id')
          AND NOT attisdropped
    ) THEN
        RAISE EXCEPTION 'climbs should only have area_id as a parent';
    END IF;
END
$$;

ROLLBACK;
