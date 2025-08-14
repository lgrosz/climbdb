-- Verify climbdb:climb-grades on pg

BEGIN;

SELECT id, climb_id, grade
    FROM climb_grades
    WHERE FALSE;

ROLLBACK;
