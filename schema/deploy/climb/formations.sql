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
COMMENT ON COLUMN climb.formations.slug IS 'User-facing identifier that hides the internal UUID from clients. NULL means the formation is not reachable via slug-based lookup.';
COMMENT ON COLUMN climb.formations.name IS 'NULL indicates the formation is unnamed.';
COMMENT ON COLUMN climb.formations.geom IS 'Optional geographic location in WGS84. NULL indicates the location is not recorded.';
COMMENT ON CONSTRAINT at_most_one_parent ON climb.formations IS 'A formation may belong to at most one parent (region, crag, or sector). A formation with no parent is valid; this is common before a crag gets well-established.';

COMMIT;
