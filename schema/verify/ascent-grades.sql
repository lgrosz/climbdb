-- Verify climbdb:ascent-grades on pg

BEGIN;

SELECT id, ascent_id, grade
    FROM ascent_grades
    WHERE FALSE;

ROLLBACK;
