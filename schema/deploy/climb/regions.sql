-- Deploy climbdb:climb/regions to pg
-- requires: climb

BEGIN;

CREATE TABLE climb.regions (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    slug TEXT UNIQUE,
    name TEXT,
    description TEXT
);

COMMENT ON TABLE climb.regions IS 'Large areas, often geographically or administratively defined. These tend not to be climbing-centric, and group multiple crags as proximate areas develop.';
COMMENT ON COLUMN climb.regions.slug IS 'User-facing identifier that hides the internal UUID from clients. NULL means the region is not reachable via slug-based lookup.';
COMMENT ON COLUMN climb.regions.name IS 'NULL indicates the region is unnamed.';

COMMIT;
