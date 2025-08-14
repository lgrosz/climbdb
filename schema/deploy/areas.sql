-- Deploy climbdb:areas to pg

BEGIN;

CREATE TABLE areas(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT CHECK (name IS NULL OR name <> ''),
    description TEXT
);

COMMIT;
