-- Deploy climbdb-seeds:refs to pg
-- requires: regions
-- requires: climbdb:climb/crags

BEGIN;

CREATE TABLE crag_seed_refs (
    ref TEXT PRIMARY KEY,
    crag_id INT NOT NULL REFERENCES climb.crags(id) ON DELETE CASCADE
);

CREATE FUNCTION crag_seed_ref(p_ref TEXT)
RETURNS TABLE(ref TEXT, crag_id INT) LANGUAGE sql STABLE AS $$
    SELECT ref, crag_id
    FROM crag_seed_refs
    WHERE ref = p_ref;
$$;

WITH last_crag AS (
    INSERT INTO climb.crags(name, region_id)
    VALUES (
        'Emancipation Rockphormation',
        (SELECT region_id FROM region_seed_ref('mount-rushmore'))
    )
    RETURNING id
)
INSERT INTO crag_seed_refs (ref, crag_id)
    SELECT 'emancipation', id FROM last_crag;

COMMIT;
