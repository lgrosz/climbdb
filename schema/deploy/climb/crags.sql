-- Deploy climbdb:climb/crags to pg
-- requires: climb
-- requires: climb/regions

BEGIN;

CREATE TABLE climb.crags (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    name TEXT,
    description TEXT,
    region_id UUID REFERENCES climb.regions(id)
);

COMMENT ON TABLE climb.crags IS 'Distinct climbing areas with limited scope.';

COMMIT;
