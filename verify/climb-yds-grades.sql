-- Verify climb-pg:climb-yds-grades on pg

BEGIN;

SELECT id, climb_id, value, letter
    FROM climb_yds_grades
    WHERE FALSE;

ROLLBACK;
