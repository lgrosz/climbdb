-- Verify climbdb:climb/regions on pg

BEGIN;

-- climb/areas later merges this table into climb.areas
DO $$
BEGIN
    IF to_regclass('climb.areas') IS NULL THEN
        PERFORM id, slug, name, description
            FROM climb.regions
            WHERE FALSE;
    END IF;
END
$$;

ROLLBACK;
