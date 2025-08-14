-- Revert climb-pg:formation-closures from pg

BEGIN;

DROP TRIGGER enforce_formation_super_area_closure_mutual_exclusivity
    ON formation_super_area_closures;
DROP TRIGGER enforce_formation_super_formation_closure_mutual_exclusivity
    ON formation_super_formation_closures;
DROP TRIGGER prevent_formation_super_formation_closures_cycle
    ON formation_super_formation_closures;

DROP FUNCTION check_no_formation_super_area_closure();
DROP FUNCTION check_no_formation_super_formation_closure();
DROP FUNCTION check_formation_super_formation_closures_cycle();

DROP TABLE formation_super_area_closures;
DROP TABLE formation_super_formation_closures;

COMMIT;
