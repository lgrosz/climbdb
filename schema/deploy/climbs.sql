-- Deploy climbdb:climbs to pg
-- requires: appschema
-- requires: regions
-- requires: crags
-- requires: sectors
-- requires: formations

BEGIN;

CREATE TABLE climb.climbs (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT,
    description TEXT,

    -- possible "parents"
    region_id INTEGER REFERENCES climb.regions(id),
    crag_id INTEGER REFERENCES climb.crags(id),
    sector_id INTEGER REFERENCES climb.sectors(id),
    formation_id INTEGER REFERENCES climb.formations(id),

    -- exclusive-or parent enforcement
    CONSTRAINT at_most_one_parent CHECK ( num_nonnulls(region_id, crag_id, sector_id, formation_id) < 2 )
);

COMMIT;
