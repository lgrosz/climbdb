-- Deploy climb-pg:areas to pg

BEGIN;

CREATE TABLE areas(
    id SERIAL NOT NULL PRIMARY KEY,
    name TEXT CHECK (name IS NULL OR name <> '')
);

COMMIT;
