-- Deploy climb-pg:formation-closures to pg
-- requires: formations
-- requires: areas

BEGIN;

CREATE TABLE climb_closures (
    climb_id INTEGER PRIMARY KEY REFERENCES climbs(id) ON DELETE CASCADE,
    super_climb_id INTEGER REFERENCES climbs(id) ON DELETE RESTRICT,
    super_formation_id INTEGER REFERENCES formations(id) ON DELETE RESTRICT,

    CHECK (
        (super_climb_id IS NOT NULL AND super_formation_id IS NULL) OR
        (super_climb_id IS NULL AND super_formation_id IS NOT NULL)
    )
);

CREATE FUNCTION check_climb_closures_cycle() RETURNS trigger AS $$
DECLARE
    v_parent_id INTEGER;
BEGIN
    v_parent_id := NEW.super_climb_id;

    WHILE v_parent_id IS NOT NULL LOOP
        IF v_parent_id = NEW.climb_id THEN
            RAISE EXCEPTION 'Climb closure cycle detected';
        END IF;
        SELECT super_climb_id INTO v_parent_id
            FROM climb_closures
            WHERE climb_id = v_parent_id;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_climb_closures_cycle
    BEFORE INSERT OR UPDATE ON climb_closures
    FOR EACH ROW EXECUTE FUNCTION check_climb_closures_cycle();

COMMIT;
