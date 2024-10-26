-- Verify climb-pg:climb-closures on pg

BEGIN;

SELECT climb_id, super_area_id, super_formation_id
    FROM climb_closures
    WHERE FALSE;

ROLLBACK;
