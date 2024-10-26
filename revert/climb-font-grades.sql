-- Revert climb-pg:climb-font-grades from pg

BEGIN;

DROP TABLE climb_font_grades;

COMMIT;
