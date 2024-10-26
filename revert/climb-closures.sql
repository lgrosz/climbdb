-- Revert climb-pg:climb-closures from pg

BEGIN;

DROP TRIGGER enforce_climb_super_area_closure_mutual_exclusivity
    ON climb_super_area_closures;
DROP TRIGGER enforce_climb_super_formation_closure_mutual_exclusivity
    ON climb_super_formation_closures;

DROP FUNCTION check_climb_closure_mutual_exclusivity();

DROP TABLE climb_super_area_closures;
DROP TABLE climb_super_formation_closures;

COMMIT;
