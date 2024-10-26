-- Verify climb-pg:climb-verm-grades on pg

BEGIN;

SELECT id, climb_id, value
    FROM climb_verm_grades
    WHERE FALSE;

ROLLBACK;
