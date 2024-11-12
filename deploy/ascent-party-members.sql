-- Deploy climb-pg:ascent-party-members to pg
-- requires: climbers
-- requires: ascents

BEGIN;

CREATE TABLE ascent_party_members(
    ascent_id INTEGER REFERENCES ascents(id) ON DELETE cascade,
    climber_id INTEGER REFERENCES climbers(id) ON DELETE restrict,
    PRIMARY KEY(ascent_id, climber_id)
);

COMMIT;
