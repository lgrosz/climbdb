-- Deploy climbdb:climb-ext to pg

BEGIN;

CREATE EXTENSION pg_climb;

COMMIT;
