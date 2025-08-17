-- Deploy climbdb:formations to pg
-- requires: appschema
-- requires: postgis

BEGIN;

CREATE TABLE climb.formations (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT,
    description TEXT,
    location geometry(POINT, 4326)
);

COMMIT;
