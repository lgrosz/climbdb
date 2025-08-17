-- Deploy climbdb:climbers to pg
-- requires: appschema

BEGIN;

CREATE TABLE climb.climbers (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL
);

COMMIT;
