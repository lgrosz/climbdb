-- Deploy climbdb-seeds:formations to pg
-- requires: sectors
-- requires: climbdb:climb/formations

BEGIN;

CREATE TABLE formation_seed_refs (
    ref TEXT PRIMARY KEY,
    formation_id INT NOT NULL REFERENCES climb.formations(id) ON DELETE CASCADE
);

CREATE FUNCTION formation_seed_ref(p_ref TEXT)
RETURNS TABLE(ref TEXT, formation_id INT) LANGUAGE sql STABLE AS $$
    SELECT ref, formation_id
    FROM formation_seed_refs
    WHERE ref = p_ref;
$$;

WITH last_formation AS (
    INSERT INTO climb.formations(name, description, sector_id)
    VALUES (
        'Atomic Boulder',
        'A generally featured, unsuspecting boulder located near the center of '
        'the talus field.',
        (SELECT sector_id FROM sector_seed_ref('manhattan'))
    )
    RETURNING id
)
INSERT INTO formation_seed_refs (ref, formation_id)
    SELECT 'atomic-boulder', id FROM last_formation;

COMMIT;
