-- Deploy climbdb:climb/rank to pg
-- requires: climb/crags
-- requires: climb/sectors
-- requires: climb/formations
-- requires: climb/climbs

BEGIN;

ALTER TABLE climb.crags ADD COLUMN rank INTEGER;
ALTER TABLE climb.sectors ADD COLUMN rank INTEGER;
ALTER TABLE climb.formations ADD COLUMN rank INTEGER;
ALTER TABLE climb.climbs ADD COLUMN rank INTEGER;

COMMENT ON COLUMN climb.crags.rank IS 'Optional ordinal among sibling crags sharing the same region. NULL means unordered. Equal ranks are intentional ties. Meaningful only relative to the row''s current parent.';
COMMENT ON COLUMN climb.sectors.rank IS 'Optional ordinal among sibling sectors sharing the same crag. NULL means unordered. Equal ranks are intentional ties. Meaningful only relative to the row''s current parent.';
COMMENT ON COLUMN climb.formations.rank IS 'Optional ordinal among sibling formations sharing the same parent. NULL means unordered. Equal ranks are intentional ties. Meaningful only relative to the row''s current parent.';
COMMENT ON COLUMN climb.climbs.rank IS 'Optional ordinal among sibling climbs sharing the same parent. NULL means unordered. Equal ranks are intentional ties. Meaningful only relative to the row''s current parent.';

-- A rank is an ordinal among siblings, so it needs a parent to be a sibling
-- within. Sectors are omitted deliberately: crag_id is NOT NULL, so a sector
-- always has a parent and the constraint would be vacuous.
ALTER TABLE climb.crags ADD CONSTRAINT rank_requires_parent
    CHECK ( rank IS NULL OR region_id IS NOT NULL );
ALTER TABLE climb.formations ADD CONSTRAINT rank_requires_parent
    CHECK ( rank IS NULL OR num_nonnulls(region_id, crag_id, sector_id) = 1 );
ALTER TABLE climb.climbs ADD CONSTRAINT rank_requires_parent
    CHECK ( rank IS NULL OR num_nonnulls(region_id, crag_id, sector_id, formation_id) = 1 );

COMMENT ON CONSTRAINT rank_requires_parent ON climb.crags IS 'A parentless crag has no siblings to be ordered among, so it cannot carry a rank. Detaching a crag from its region must clear the rank in the same statement.';
COMMENT ON CONSTRAINT rank_requires_parent ON climb.formations IS 'A parentless formation has no siblings to be ordered among, so it cannot carry a rank. Detaching a formation from its parent must clear the rank in the same statement.';
COMMENT ON CONSTRAINT rank_requires_parent ON climb.climbs IS 'A parentless climb has no siblings to be ordered among, so it cannot carry a rank. Detaching a climb from its parent must clear the rank in the same statement.';

COMMIT;
