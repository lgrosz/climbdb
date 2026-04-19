-- Deploy climbdb:climb/regions to pg
-- requires: climb

BEGIN;

CREATE TABLE climb.regions (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    name TEXT,
    description TEXT
);

COMMENT ON TABLE climb.regions IS 'Large areas, often geographically or administrativly defined. These tend not to be climbing-centric.';

COMMIT;
