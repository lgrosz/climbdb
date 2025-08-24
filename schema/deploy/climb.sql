-- Deploy climbdb:climb to pg

BEGIN;

CREATE SCHEMA climb;

COMMENT ON SCHEMA climb IS 'Climbing related objects.';

COMMIT;
