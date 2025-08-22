-- Deploy climbdb:formations to pg
-- requires: climb
-- requires: postgis
-- requires: regions
-- requires: crags
-- requires: sectors

BEGIN;

CREATE TABLE climb.formations (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT,
    description TEXT,
    location geometry(POINT, 4326),

    -- possible "parents"
    region_id INTEGER REFERENCES climb.regions(id),
    crag_id INTEGER REFERENCES climb.crags(id),
    sector_id INTEGER REFERENCES climb.sectors(id),

    -- exclusive-or parent enforcement
    CONSTRAINT at_most_one_parent CHECK ( num_nonnulls(region_id, crag_id, sector_id) < 2 )
);

COMMIT;
