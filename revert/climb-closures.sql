-- Revert climb-pg:climb-closures from pg

BEGIN;

DROP TRIGGER enforce_climb_super_area_closure_mutual_exclusivity
    ON climb_super_area_closures;
DROP TRIGGER enforce_climb_super_formation_closure_mutual_exclusivity
    ON climb_super_formation_closures;

DROP FUNCTION check_no_climb_super_area_closure();
DROP FUNCTION check_no_climb_super_formation_closure();

DROP TABLE climb_super_area_closures;
DROP TABLE climb_super_formation_closures;

COMMIT;
