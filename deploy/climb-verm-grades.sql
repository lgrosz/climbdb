-- Deploy climb-pg:climb-verm-grades to pg
-- requires: climbs

BEGIN;

CREATE TABLE climb_verm_grades (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    climb_id INTEGER NOT NULL REFERENCES climbs(id) ON DELETE cascade,
    value INTEGER NOT NULL CHECK (value >= 0),
    UNIQUE (climb_id, value)
);

COMMIT;
