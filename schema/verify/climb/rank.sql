-- Verify climbdb:climb/rank on pg

BEGIN;

SELECT rank FROM climb.crags WHERE FALSE;
SELECT rank FROM climb.sectors WHERE FALSE;
SELECT rank FROM climb.formations WHERE FALSE;
SELECT rank FROM climb.climbs WHERE FALSE;

DO $$
DECLARE
    missing TEXT;
BEGIN
    SELECT string_agg(t, ', ')
      INTO missing
      FROM unnest(ARRAY['climb.crags', 'climb.formations', 'climb.climbs']) AS t
     WHERE NOT EXISTS (
         SELECT FROM pg_constraint
         WHERE conrelid = t::regclass
           AND conname = 'rank_requires_parent'
     );

    IF missing IS NOT NULL THEN
        RAISE EXCEPTION 'rank_requires_parent should have been added to %', missing;
    END IF;
END
$$;

ROLLBACK;
