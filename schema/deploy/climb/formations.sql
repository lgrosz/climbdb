-- Deploy climbdb:climb/formations to pg
-- requires: climb
-- requires: postgis
-- requires: climb/regions
-- requires: climb/crags
-- requires: climb/sectors

BEGIN;

CREATE TABLE climb.formations (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    slug TEXT UNIQUE,
    name TEXT,
    description TEXT,
    geom geometry(Geometry, 4326),

    -- possible "parents"
    region_id UUID REFERENCES climb.regions(id),
    crag_id UUID REFERENCES climb.crags(id),
    sector_id UUID REFERENCES climb.sectors(id),

    -- exclusive-or parent enforcement
    CONSTRAINT at_most_one_parent CHECK ( num_nonnulls(region_id, crag_id, sector_id) < 2 )
);

COMMENT ON TABLE climb.formations IS 'Distinct geological formations.';

COMMIT;
