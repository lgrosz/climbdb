-- Revert climb-pg:ascent-grades from pg

BEGIN;

DROP TABLE ascent_grades;

COMMIT;
