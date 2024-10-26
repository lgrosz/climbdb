-- Deploy climb-pg:formation-closures to pg
-- requires: formations
-- requires: areas

BEGIN;

CREATE TABLE climb_closures (
    climb_id INTEGER PRIMARY KEY REFERENCES climbs(id) ON DELETE CASCADE,
    super_area_id INTEGER REFERENCES areas(id) ON DELETE RESTRICT,
    super_formation_id INTEGER REFERENCES formations(id) ON DELETE RESTRICT,

    CHECK (
        (super_area_id IS NOT NULL AND super_formation_id IS NULL) OR
        (super_area_id IS NULL AND super_formation_id IS NOT NULL)
    )
);

COMMIT;
