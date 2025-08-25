-- Deploy climbdb-seeds:refs to pg
-- requires: climbdb:climb/regions

BEGIN;

CREATE TABLE region_seed_refs (
    ref TEXT PRIMARY KEY,
    region_id INT NOT NULL REFERENCES climb.regions(id) ON DELETE CASCADE
);

-- TODO I'd like this to return the row of the regions table
CREATE FUNCTION region_seed_ref(p_ref TEXT)
RETURNS TABLE(ref TEXT, region_id INT) LANGUAGE sql STABLE AS $$
    SELECT ref, region_id
    FROM region_seed_refs
    WHERE ref = p_ref;
$$;

-- TODO It's often that I only need the id, so maybe a second function that
-- does specifically that

WITH last_region AS (
    INSERT INTO climb.regions(name)
    VALUES ('Mount Rushmore')
    RETURNING id
)
INSERT INTO region_seed_refs (ref, region_id)
    SELECT 'mount-rushmore', id FROM last_region;

COMMIT;
