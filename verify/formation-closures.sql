-- Verify climb-pg:formation-closures on pg

BEGIN;

SELECT formation_id, super_formation_id, super_area_id
    FROM formation_closures
    WHERE FALSE;

-- TODO Verify function existence

-- TODO Verify trigger existence

ROLLBACK;
