-- Deploy climb-pg:climb-ext to pg

BEGIN;

CREATE EXTENSION pg_climb;

COMMIT;
