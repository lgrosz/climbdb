-- Deploy climbdb:climb/climbs to pg
-- requires: climb
-- requires: climb/regions
-- requires: climb/crags
-- requires: climb/sectors
-- requires: climb/formations

BEGIN;

CREATE TABLE climb.climbs (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    slug TEXT UNIQUE,
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
COMMENT ON COLUMN climb.climbs.slug IS 'User-facing identifier that hides the internal UUID from clients. NULL means the climb is not reachable via slug-based lookup.';
COMMENT ON COLUMN climb.climbs.name IS 'NULL indicates the climb is unnamed.';
COMMENT ON COLUMN climb.climbs.grade IS 'Placeholder TEXT type. A proper grade domain type is planned for a future version. No database-level validation is enforced; callers are responsible for format consistency.';
-- TODO It makes sense to give a climb a location in cases like sport climbing walls, where the point would be projected on to the wall to determine its starting location. This makes sense sense for boulders. This also reduces the need for "anonymous formations"
COMMENT ON CONSTRAINT at_most_one_parent ON climb.climbs IS 'A climb may belong to at most one parent (region, crag, sector, or formation). A climb with no parent is valid, usually for a climb where its location is not known.';

COMMIT;
