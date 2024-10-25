-- Revert climb-pg:climb-closures from pg

BEGIN;

DROP TRIGGER prevent_climb_closures_cycle ON climb_closures;
DROP FUNCTION check_climb_closures_cycle();
DROP TABLE climb_closures;

COMMIT;
