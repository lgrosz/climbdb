-- Deploy climbdb:climb/ascent-members to pg
-- requires: climb
-- requires: climb/ascents
-- requires: climb/climbers

BEGIN;

CREATE TABLE climb.ascent_members (
    ascent_id INTEGER NOT NULL REFERENCES climb.ascents(id) ON DELETE CASCADE,
    climber_id INTEGER NOT NULL REFERENCES climb.climbers(id),
    PRIMARY KEY (ascent_id, climber_id)
);

COMMENT ON TABLE climb.ascent_members IS 'Describes members of an ascent party';

COMMIT;
