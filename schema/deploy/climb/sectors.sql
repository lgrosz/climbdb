-- Deploy climbdb:climb/sectors to pg
-- requires: climb
-- requires: climb/crags

BEGIN;

CREATE TABLE climb.sectors (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    slug TEXT UNIQUE,
    name TEXT,
    description TEXT,
    crag_id UUID NOT NULL REFERENCES climb.crags(id)
);

COMMENT ON TABLE climb.sectors IS 'Subdivisions of a crag. Generally used for organization purposes to further specify or group formations or climbs.';

COMMIT;
