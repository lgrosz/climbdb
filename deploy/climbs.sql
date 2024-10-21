-- Deploy climb-pg:climbs to pg

BEGIN;

CREATE TABLE climbs(
    id SERIAL PRIMARY KEY,
    name TEXT CHECK (name IS NULL OR name <> '')
);

COMMIT;
