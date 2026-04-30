-- Deploy climbdb:climb/crags to pg
-- requires: climb
-- requires: climb/regions

BEGIN;

CREATE TABLE climb.crags (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    slug TEXT UNIQUE,
    name TEXT,
    description TEXT,
    region_id UUID REFERENCES climb.regions(id)
);

COMMENT ON TABLE climb.crags IS 'Distinct climbing areas with limited scope. These are often climbing-centric.';
COMMENT ON COLUMN climb.crags.slug IS 'User-facing identifier that hides the internal UUID from clients. NULL means the crag is not reachable via slug-based lookup.';
COMMENT ON COLUMN climb.crags.name IS 'NULL indicates the crag is unnamed.';
COMMENT ON COLUMN climb.crags.region_id IS 'Optional. A crag without a region is valid; regions emerge once multiple crags develop in proximity.';

COMMIT;
