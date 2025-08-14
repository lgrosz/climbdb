-- Revert climbdb:ascent-grades from pg

BEGIN;

DROP TABLE ascent_grades;

COMMIT;
