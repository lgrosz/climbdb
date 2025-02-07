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

-- Raises an exception if there is a super area closure
CREATE FUNCTION check_no_climb_super_area_closure()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM climb_super_area_closures WHERE climb_id = NEW.climb_id) THEN
        RAISE EXCEPTION 'super area closure exists';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Raises an exception if there is a super formation closure
CREATE FUNCTION check_no_climb_super_formation_closure()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM climb_super_formation_closures WHERE climb_id = NEW.climb_id) THEN
        RAISE EXCEPTION 'super formation closure exists';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_climb_super_area_closure_mutual_exclusivity
    BEFORE INSERT ON climb_super_area_closures
    FOR EACH ROW EXECUTE FUNCTION check_no_climb_super_formation_closure();

CREATE TRIGGER enforce_climb_super_formation_closure_mutual_exclusivity
    BEFORE INSERT ON climb_super_formation_closures
    FOR EACH ROW EXECUTE FUNCTION check_no_climb_super_area_closure();


COMMIT;
