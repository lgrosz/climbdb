-- Deploy climb-pg:area-closures to pg
-- requires: areas

BEGIN;

CREATE TABLE area_closures (
    area_id INTEGER PRIMARY KEY REFERENCES areas(id) ON DELETE CASCADE,
    super_area_id INTEGER NOT NULL REFERENCES areas(id) ON DELETE RESTRICT
);

CREATE FUNCTION check_area_closures_cycle() RETURNS trigger AS $$
DECLARE
    v_parent_id INTEGER;
BEGIN
    v_parent_id := NEW.super_area_id;

    WHILE v_parent_id IS NOT NULL LOOP
        IF v_parent_id = NEW.area_id THEN
            RAISE EXCEPTION 'Area closure cycle detected';
        END IF;
        SELECT super_area_id INTO v_parent_id
            FROM area_closures
            WHERE area_id = v_parent_id;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_area_closures_cycle
    BEFORE INSERT OR UPDATE ON area_closures
    FOR EACH ROW EXECUTE FUNCTION check_area_closures_cycle();

COMMIT;
