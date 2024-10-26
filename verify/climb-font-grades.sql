-- Verify climb-pg:climb-font-grades on pg

BEGIN;

SELECT id, climb_id, value, plus, letter
    FROM climb_font_grades
    WHERE FALSE;

ROLLBACK;
