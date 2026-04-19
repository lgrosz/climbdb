-- Deploy climbdb:climb/climbers to pg
-- requires: climb

BEGIN;

CREATE TABLE climb.climbers (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL
);

COMMENT ON TABLE climb.climbers IS 'Describes a person as a climber.';

COMMIT;
