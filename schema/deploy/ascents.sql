-- Deploy climbdb:ascents to pg
-- requires: climbers
-- requires: climbs

BEGIN;

CREATE TABLE ascents(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    climb_id INTEGER NOT NULL REFERENCES climbs(id) ON DELETE cascade,
    climber_id INTEGER NOT NULL REFERENCES climbers(id) ON DELETE cascade,
    date_window DATERANGE
);

COMMIT;
