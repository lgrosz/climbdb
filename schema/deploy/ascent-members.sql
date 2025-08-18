-- Deploy climbdb:ascent-members to pg
-- requires: appschema
-- requires: ascents
-- requires: climbers

BEGIN;

CREATE TABLE climb.ascent_members (
    ascent_id INTEGER NOT NULL REFERENCES climb.ascents(id) ON DELETE CASCADE,
    climber_id INTEGER NOT NULL REFERENCES climb.climbers(id)
);

COMMIT;
