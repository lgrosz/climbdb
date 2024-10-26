-- Deploy climb-pg:formation-closures to pg
-- requires: formations
-- requires: areas

BEGIN;

CREATE TABLE climb_super_area_closures (
    climb_id INTEGER PRIMARY KEY REFERENCES climbs(id) ON DELETE CASCADE,
    super_area_id INTEGER NOT NULL REFERENCES areas(id) ON DELETE RESTRICT
);

CREATE TABLE climb_super_formation_closures (
    climb_id INTEGER PRIMARY KEY REFERENCES climbs(id) ON DELETE CASCADE,
    super_formation_id INTEGER NOT NULL REFERENCES formations(id) ON DELETE RESTRICT
);

CREATE FUNCTION check_climb_closure_mutual_exclusivity()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM climb_super_area_closures WHERE climb_id = NEW.climb_id) THEN
        RAISE EXCEPTION 'this climb already belongs to an area';
    END IF;

    IF EXISTS (SELECT 1 FROM climb_super_formation_closures WHERE climb_id = NEW.climb_id) THEN
        RAISE EXCEPTION 'this climb already belongs to a formation';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_climb_super_area_closure_mutual_exclusivity
    BEFORE INSERT ON climb_super_area_closures
    FOR EACH ROW EXECUTE FUNCTION check_climb_closure_mutual_exclusivity();

CREATE TRIGGER enforce_climb_super_formation_closure_mutual_exclusivity
    BEFORE INSERT ON climb_super_formation_closures
    FOR EACH ROW EXECUTE FUNCTION check_climb_closure_mutual_exclusivity();


COMMIT;
