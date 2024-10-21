-- Verify climb-pg:area-closures on pg

BEGIN;

SELECT area_id, super_area_id
    FROM area_closures
    WHERE FALSE;

-- TODO Verify function existence

-- TODO Verify trigger existence

ROLLBACK;
