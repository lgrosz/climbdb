-- Revert climbdb:area-closures from pg

BEGIN;

DROP TRIGGER prevent_area_closures_cycle ON area_closures;
DROP FUNCTION check_area_closures_cycle();
DROP TABLE area_closures;

COMMIT;
