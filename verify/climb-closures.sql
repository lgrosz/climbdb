-- Verify climb-pg:climb-closures on pg

BEGIN;

SELECT climb_id, super_climb_id, super_formation_id
    FROM climb_closures
    WHERE FALSE;

-- TODO Verify function existence

-- TODO Verify trigger existence

ROLLBACK;
