-- Deploy climb-pg:formation-closures to pg
-- requires: formations
-- requires: areas

BEGIN;

CREATE TABLE formation_super_area_closures (
    formation_id INTEGER PRIMARY KEY REFERENCES formations(id) ON DELETE CASCADE,
    super_area_id INTEGER NOT NULL REFERENCES areas(id) ON DELETE RESTRICT
);

CREATE TABLE formation_super_formation_closures (
    formation_id INTEGER PRIMARY KEY REFERENCES formations(id) ON DELETE CASCADE,
    super_formation_id INTEGER NOT NULL REFERENCES formations(id) ON DELETE RESTRICT
);

-- Raises an exception if there is a super area closure
CREATE FUNCTION check_no_formation_super_area_closure()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM formation_super_area_closures WHERE formation_id = NEW.formation_id) THEN
        RAISE EXCEPTION 'super area closure exists';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Raises an exception if there is a super formation closure
CREATE FUNCTION check_no_formation_super_formation_closure()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM formation_super_formation_closures WHERE formation_id = NEW.formation_id) THEN
        RAISE EXCEPTION 'super formation closure exists';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION check_formation_super_formation_closures_cycle() RETURNS trigger AS $$
DECLARE
    v_parent_id INTEGER;
BEGIN
    v_parent_id := NEW.super_formation_id;

    WHILE v_parent_id IS NOT NULL LOOP
        IF v_parent_id = NEW.formation_id THEN
            RAISE EXCEPTION 'Formation closure cycle detected';
        END IF;
        SELECT super_formation_id INTO v_parent_id
            FROM formation_super_formation_closures
            WHERE formation_id = v_parent_id;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enforce_formation_super_area_closure_mutual_exclusivity
    BEFORE INSERT ON formation_super_area_closures
    FOR EACH ROW EXECUTE FUNCTION check_no_formation_super_formation_closure();

CREATE TRIGGER enforce_formation_super_formation_closure_mutual_exclusivity
    BEFORE INSERT ON formation_super_formation_closures
    FOR EACH ROW EXECUTE FUNCTION check_no_formation_super_area_closure();

CREATE TRIGGER prevent_formation_super_formation_closures_cycle
    BEFORE INSERT OR UPDATE ON formation_super_formation_closures
    FOR EACH ROW EXECUTE FUNCTION check_formation_super_formation_closures_cycle();


COMMIT;
