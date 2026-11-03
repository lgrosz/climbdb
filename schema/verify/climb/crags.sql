-- Verify climbdb:climb/crags on pg

BEGIN;

-- climb/areas later merges this table into climb.areas
DO $$
BEGIN
    IF to_regclass('climb.areas') IS NULL THEN
        PERFORM id, slug, name, description, region_id
            FROM climb.crags
            WHERE FALSE;
    END IF;
END
$$;

ROLLBACK;
