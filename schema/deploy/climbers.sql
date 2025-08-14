-- Deploy climbdb:climbers to pg

BEGIN;

CREATE TABLE climbers(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL
);

COMMIT;
