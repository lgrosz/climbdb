-- Deploy climb-pg:formations to pg
-- requires: postgis

BEGIN;

CREATE TABLE formations(
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT CHECK (name IS NULL OR name <> ''),
    location geometry(POINT, 4326)
);

COMMIT;
