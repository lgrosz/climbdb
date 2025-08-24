-- Deploy climbdb:media to pg

BEGIN;

CREATE SCHEMA media;

COMMENT ON SCHEMA media IS 'Media related objects.';

COMMIT;
