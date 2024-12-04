-- Revert climb-pg:climb-description-types-defaults from pg

BEGIN;

DELETE FROM climb_description_types
    WHERE name = 'description';

COMMIT;
