-- Deploy climbdb:regions to pg
-- requires: climb

BEGIN;

CREATE TABLE climb.regions (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT
);

COMMENT ON TABLE climb.regions IS 'Large areas, often geographically or administrativly defined. These tend not to be climbing-centric.';

COMMIT;
