-- Deploy climbdb:climb/ascents to pg
-- requires: climb
-- requires: climb/climbs

BEGIN;

CREATE TABLE climb.ascents (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    climb_id INTEGER NOT NULL REFERENCES climb.climbs(id) ON DELETE CASCADE,
    ascent_window DATERANGE,
    ascent_duration INTERVAL,
    first_ascent BOOLEAN NOT NULL,
    members_complete BOOLEAN NOT NULL,
    verified BOOLEAN NOT NULL
);

COMMENT ON TABLE climb.ascents IS 'Describes an ascent event of a climb';

COMMIT;
