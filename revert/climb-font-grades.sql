-- Revert climb-pg:climb-font-grades from pg

BEGIN;

DROP TRIGGER enforce_letter_constraint ON climb_font_grades;
DROP FUNCTION check_font_letter();
DROP TABLE climb_font_grades;

COMMIT;
