-- Revert climb-pg:climb-yds-grades from pg

BEGIN;

DROP TABLE climb_yds_grades;

COMMIT;
