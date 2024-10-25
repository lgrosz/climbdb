-- Revert climb-pg:formation-closures from pg

BEGIN;

DROP TRIGGER prevent_formation_closures_cycle ON formation_closures;
DROP FUNCTION check_formation_closures_cycle();
DROP TABLE formation_closures;

COMMIT;
