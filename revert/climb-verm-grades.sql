-- Revert climb-pg:climb-verm-grades from pg

BEGIN;

DROP TABLE climb_verm_grades;

COMMIT;
