-- Deploy climbdb:climb/climbers to pg
-- requires: climb

BEGIN;

CREATE TABLE climb.climbers (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    slug TEXT UNIQUE,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL
);

COMMENT ON TABLE climb.climbers IS 'Describes a person as a climber.';
COMMENT ON COLUMN climb.climbers.slug IS 'User-facing identifier that hides the internal UUID from clients. NULL means the climber is not reachable via slug-based lookup.';
COMMENT ON COLUMN climb.climbers.first_name IS 'Required. Climbers represent identified individuals, so a name is mandatory.';
COMMENT ON COLUMN climb.climbers.last_name IS 'Required. See first_name.';

COMMIT;
