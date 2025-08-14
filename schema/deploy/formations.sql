-- Deploy climbdb:formations to pg
-- requires: postgis

BEGIN;

CREATE TABLE formations(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT CHECK (name IS NULL OR name <> ''),
    description TEXT,
    location geometry(POINT, 4326)
);

COMMIT;
