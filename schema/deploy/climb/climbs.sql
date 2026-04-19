-- Deploy climbdb:climb/climbs to pg
-- requires: climb
-- requires: climb/regions
-- requires: climb/crags
-- requires: climb/sectors
-- requires: climb/formations

BEGIN;

CREATE TABLE climb.climbs (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    name TEXT,
    description TEXT,
    grade TEXT,

    -- possible "parents"
    region_id UUID REFERENCES climb.regions(id),
    crag_id UUID REFERENCES climb.crags(id),
    sector_id UUID REFERENCES climb.sectors(id),
    formation_id UUID REFERENCES climb.formations(id),

    -- exclusive-or parent enforcement
    CONSTRAINT at_most_one_parent CHECK ( num_nonnulls(region_id, crag_id, sector_id, formation_id) < 2 )
);

COMMENT ON TABLE climb.climbs IS 'Describes any climbing route.';

COMMIT;
