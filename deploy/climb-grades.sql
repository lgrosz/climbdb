-- Deploy climb-pg:climb-grades to pg
-- requires: climbs
-- requires: climb-ext

BEGIN;

CREATE TABLE climb_grades (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    climb_id INTEGER NOT NULL REFERENCES climbs(id) ON DELETE cascade,
    grade grade,
    UNIQUE (climb_id, grade)
);

COMMIT;
