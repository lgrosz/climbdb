-- Deploy climbdb-seeds:climbers to pg
-- requires: climbdb:climb/climbers

BEGIN;

CREATE TABLE climber_seed_refs (
    ref TEXT PRIMARY KEY,
    climber_id UUID NOT NULL REFERENCES climb.climbers(id) ON DELETE CASCADE
);

CREATE FUNCTION climber_seed_ref(p_ref TEXT)
RETURNS TABLE(ref TEXT, climber_id UUID) LANGUAGE sql STABLE AS $$
    SELECT ref, climber_id
    FROM climber_seed_refs
    WHERE ref = p_ref;
$$;

WITH last_climber AS (
    INSERT INTO climb.climbers(first_name, last_name)
    VALUES (
        'Josh',
        'Dreher'
    )
    RETURNING id
)
INSERT INTO climber_seed_refs (ref, climber_id)
    SELECT 'josh-dreher', id FROM last_climber;

COMMIT;
