-- Deploy climb-pg:climbs to pg

BEGIN;

CREATE TABLE climbs(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT CHECK (name IS NULL OR name <> '')
);

COMMIT;
