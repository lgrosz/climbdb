-- Deploy climbdb-seeds:ascents to pg
-- requires: climbs
-- requires: climbdb:climb/ascents

BEGIN;

CREATE TABLE ascent_seed_refs (
    ref TEXT PRIMARY KEY,
    ascent_id UUID NOT NULL REFERENCES climb.ascents(id) ON DELETE CASCADE
);

CREATE FUNCTION ascent_seed_ref(p_ref TEXT)
RETURNS TABLE(ref TEXT, ascent_id UUID) LANGUAGE sql STABLE AS $$
    SELECT ref, ascent_id
    FROM ascent_seed_refs
    WHERE ref = p_ref;
$$;

WITH last_ascent AS (
    INSERT INTO climb.ascents (
        climb_id,
        ascent_window,
        significance
    ) VALUES (
        (SELECT id FROM climb.climbs WHERE slug = 'atomic-decay'),
        '[2009-06-01,2009-07-01)'::daterange,
        '{fa}'
    ) RETURNING id
)
INSERT INTO ascent_seed_refs (ref, ascent_id)
    SELECT 'atomic-decay-fa', id FROM last_ascent;

COMMIT;
