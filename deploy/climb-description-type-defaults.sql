-- Deploy climb-pg:climb-description-types-defaults to pg
-- requires: climb-description-types

BEGIN;

INSERT INTO climb_description_types(name)
    VALUES ('description');

COMMIT;
