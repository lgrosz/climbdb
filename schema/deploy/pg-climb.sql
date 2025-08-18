-- Deploy climbdb:pg-climb to pg

BEGIN;

CREATE EXTENSION pg_climb VERSION '1.0';

COMMIT;
