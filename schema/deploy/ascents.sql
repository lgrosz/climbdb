-- Deploy climbdb:ascents to pg
-- requires: appschema
-- requires: climbs

BEGIN;

CREATE TABLE climb.ascents (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ascent_window DATERANGE,
    ascent_duration INTERVAL,
    members_incomplete BOOLEAN NOT NULL
);

COMMIT;
