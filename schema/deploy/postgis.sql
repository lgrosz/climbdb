-- Deploy climbdb:postgis to pg

BEGIN;

CREATE EXTENSION postgis VERSION '3.6.0';

COMMIT;
