-- Verify climb-pg:climb-description-types-defaults on pg

BEGIN;

SELECT 1/count(*)
    FROM climb_description_types
    WHERE name = 'description';

ROLLBACK;
