-- Deploy climb-pg:areas to pg

BEGIN;

CREATE TABLE areas(
    id SERIAL PRIMARY KEY,
    name TEXT CHECK (name IS NULL OR name <> '')
);

COMMIT;
