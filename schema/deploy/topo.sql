-- Deploy climbdb:topo to pg

BEGIN;

CREATE SCHEMA topo;

COMMENT ON SCHEMA topo IS 'Contains objects to describe topos, annotations to describe climbing beta visually.';

COMMIT;
