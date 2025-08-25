-- Deploy climbdb-seeds:refs to pg
-- requires: crags
-- requires: climbdb:climb/sectors

BEGIN;

CREATE TABLE sector_seed_refs (
    ref TEXT PRIMARY KEY,
    sector_id INT NOT NULL REFERENCES climb.sectors(id) ON DELETE CASCADE
);

CREATE FUNCTION sector_seed_ref(p_ref TEXT)
RETURNS TABLE(ref TEXT, sector_id INT) LANGUAGE sql STABLE AS $$
    SELECT ref, sector_id
    FROM sector_seed_refs
    WHERE ref = p_ref;
$$;

WITH last_sector AS (
    INSERT INTO climb.sectors(name, crag_id)
    VALUES (
        'Manhattan',
        (SELECT crag_id FROM crag_seed_ref('emancipation'))
    )
    RETURNING id
)
INSERT INTO sector_seed_refs (ref, sector_id)
    SELECT 'manhattan', id FROM last_sector;

COMMIT;
