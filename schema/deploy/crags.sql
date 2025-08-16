-- Deploy climbdb:crags to pg
-- requires: appschema
-- requires: regions

BEGIN;

CREATE TABLE climb.crags (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT,
    region_id INTEGER REFERENCES climb.regions(id)
);

COMMENT ON TABLE climb.crags IS 'Distinct climbing areas with limited scope.';

COMMIT;
