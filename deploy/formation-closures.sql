-- Deploy climb-pg:formation-closures to pg
-- requires: formations
-- requires: areas

BEGIN;

CREATE TABLE formation_closures (
    formation_id INTEGER PRIMARY KEY REFERENCES formations(id) ON DELETE CASCADE,
    super_formation_id INTEGER REFERENCES formations(id) ON DELETE RESTRICT,
    super_area_id INTEGER REFERENCES areas(id) ON DELETE RESTRICT,

    CHECK (
        (super_formation_id IS NOT NULL AND super_area_id IS NULL) OR
        (super_formation_id IS NULL AND super_area_id IS NOT NULL)
    )
);

CREATE FUNCTION check_formation_closures_cycle() RETURNS trigger AS $$
DECLARE
    v_parent_id INTEGER;
BEGIN
    v_parent_id := NEW.super_formation_id;

    WHILE v_parent_id IS NOT NULL LOOP
        IF v_parent_id = NEW.formation_id THEN
            RAISE EXCEPTION 'Formation closure cycle detected';
        END IF;
        SELECT super_formation_id INTO v_parent_id
            FROM formation_closures
            WHERE formation_id = v_parent_id;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_formation_closures_cycle
    BEFORE INSERT OR UPDATE ON formation_closures
    FOR EACH ROW EXECUTE FUNCTION check_formation_closures_cycle();

COMMIT;
