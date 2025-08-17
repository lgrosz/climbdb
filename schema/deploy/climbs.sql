-- Deploy climbdb:climbs to pg

BEGIN;

CREATE TABLE climbs(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT,
    description TEXT
);

COMMIT;
