-- Revert climb-pg:climb-yds-grades from pg

BEGIN;

DROP TRIGGER enforce_letter_constraint ON climb_yds_grades;
DROP FUNCTION check_yds_letter();
DROP TABLE climb_yds_grades;

COMMIT;
