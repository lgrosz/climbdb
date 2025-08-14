-- Deploy climbdb:ascent-grades to pg
-- requires: ascents
-- requires: climb-ext

BEGIN;

CREATE TABLE ascent_grades (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ascent_id INTEGER NOT NULL REFERENCES ascents(id) ON DELETE cascade,
    grade grade,
    UNIQUE (ascent_id, grade)
);

COMMIT;
