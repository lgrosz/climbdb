-- Deploy climbdb-seeds:climbs to pg
-- requires: climbdb:climb/climbs
-- requires: climbs

BEGIN;

CREATE TABLE climb_seed_refs (
    ref TEXT PRIMARY KEY,
    climb_id UUID NOT NULL REFERENCES climb.climbs(id) ON DELETE CASCADE
);

CREATE FUNCTION climb_seed_ref(p_ref TEXT)
RETURNS TABLE(ref TEXT, climb_id UUID) LANGUAGE sql STABLE AS $$
    SELECT ref, climb_id
    FROM climb_seed_refs
    WHERE ref = p_ref;
$$;

WITH last_climb AS (
    INSERT INTO climb.climbs(name, description, grade, formation_id)
    VALUES (
        'Atomic Decay',
        'Sit start, matched in the undercling-crack. Follow the rails out the '
        'shelf, then up the arete.',
        'V7',
        (SELECT formation_id FROM formation_seed_ref('atomic-boulder'))
    )
    RETURNING id
)
INSERT INTO climb_seed_refs (ref, climb_id)
    SELECT 'atomic-decay', id FROM last_climb;

COMMIT;
