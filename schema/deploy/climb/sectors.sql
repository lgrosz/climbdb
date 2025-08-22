-- Deploy climbdb:climb/sectors to pg
-- requires: climb
-- requires: climb/crags

BEGIN;

CREATE TABLE climb.sectors (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT,
    crag_id INTEGER NOT NULL REFERENCES climb.crags(id)
);

COMMENT ON TABLE climb.sectors IS 'Subdivisions of a crag. Generally used for organization purposes to further specify or group formations or climbs.';

COMMIT;
