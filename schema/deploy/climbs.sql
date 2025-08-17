-- Deploy climbdb:climbs to pg
-- requires: appschema

BEGIN;

CREATE TABLE climb.climbs (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT,
    description TEXT
);

COMMIT;
