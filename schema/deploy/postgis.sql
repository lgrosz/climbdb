-- Deploy climbdb:postgis to pg

BEGIN;

CREATE EXTENSION postgis VERSION '3.5.3';

COMMIT;
