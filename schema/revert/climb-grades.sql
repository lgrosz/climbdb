-- Revert climbdb:climb-grades from pg

BEGIN;

DROP TABLE climb_grades;

COMMIT;
