-- Revert climbdb:climb/areas from pg

BEGIN;

-- An area doesn't record which table it came from, so that is inferred from its
-- shape. The rows keep their ids and places, but not necessarily their tables:
--   - a childless area at depth 4, or with a geometry, becomes a formation
--   - any other area becomes a region, crag, or sector by depth
CREATE TEMPORARY TABLE reverted_areas ON COMMIT DROP AS
    WITH RECURSIVE tree AS (
        SELECT id, 1 AS depth FROM climb.areas WHERE parent_id IS NULL
        UNION ALL
        SELECT a.id, tree.depth + 1
            FROM climb.areas a
            JOIN tree ON a.parent_id = tree.id
    )
    SELECT
        a.*,
        tree.depth,
        EXISTS (SELECT FROM climb.areas c WHERE c.parent_id = a.id) AS has_children,
        CASE
            WHEN NOT EXISTS (SELECT FROM climb.areas c WHERE c.parent_id = a.id)
                AND (tree.depth = 4 OR a.geom IS NOT NULL) THEN 'formation'
            WHEN tree.depth = 1 THEN 'region'
            WHEN tree.depth = 2 THEN 'crag'
            WHEN tree.depth = 3 THEN 'sector'
        END AS kind
    FROM climb.areas a
    JOIN tree ON tree.id = a.id;

-- Refuse to revert if the previous tables can't hold the tree
DO $$
DECLARE
    unexpected TEXT[];
BEGIN
    SELECT array_agg(id::text)
        INTO unexpected
        FROM reverted_areas
        WHERE depth > 4;

    IF unexpected IS NOT NULL THEN
        RAISE EXCEPTION 'cannot revert areas: % nested deeper than 4 levels', unexpected
            USING HINT = 'Move these areas up the tree, then revert again.';
    END IF;

    SELECT array_agg(id::text)
        INTO unexpected
        FROM reverted_areas
        WHERE geom IS NOT NULL AND has_children;

    IF unexpected IS NOT NULL THEN
        RAISE EXCEPTION 'cannot revert areas: geometry on % would be lost', unexpected
            USING HINT = 'Only childless areas can keep a geometry. Clear these, then revert again.';
    END IF;
END
$$;

CREATE TABLE climb.regions (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    slug TEXT UNIQUE,
    name TEXT,
    description TEXT
);

COMMENT ON TABLE climb.regions IS 'Large areas, often geographically or administratively defined. These tend not to be climbing-centric, and group multiple crags as proximate areas develop.';
COMMENT ON COLUMN climb.regions.slug IS 'User-facing identifier that hides the internal UUID from clients. NULL means the region is not reachable via slug-based lookup.';
COMMENT ON COLUMN climb.regions.name IS 'NULL indicates the region is unnamed.';

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

CREATE TABLE climb.sectors (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    slug TEXT UNIQUE,
    name TEXT,
    description TEXT,
    crag_id UUID NOT NULL REFERENCES climb.crags(id)
);

COMMENT ON TABLE climb.sectors IS 'Subdivisions of a crag. Generally used for organization purposes to further specify or group formations or climbs.';
COMMENT ON COLUMN climb.sectors.slug IS 'User-facing identifier that hides the internal UUID from clients. NULL means the sector is not reachable via slug-based lookup.';
COMMENT ON COLUMN climb.sectors.name IS 'NULL indicates the sector is unnamed.';
COMMENT ON COLUMN climb.sectors.crag_id IS 'Sectors have no independent existence outside of a crag.';

CREATE TABLE climb.formations (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    slug TEXT UNIQUE,
    name TEXT,
    description TEXT,
    geom geometry(Geometry, 4326),

    -- possible "parents"
    region_id UUID REFERENCES climb.regions(id),
    crag_id UUID REFERENCES climb.crags(id),
    sector_id UUID REFERENCES climb.sectors(id),

    -- exclusive-or parent enforcement
    CONSTRAINT at_most_one_parent CHECK ( num_nonnulls(region_id, crag_id, sector_id) < 2 )
);

COMMENT ON TABLE climb.formations IS 'Distinct geological formations.';
COMMENT ON COLUMN climb.formations.slug IS 'User-facing identifier that hides the internal UUID from clients. NULL means the formation is not reachable via slug-based lookup.';
COMMENT ON COLUMN climb.formations.name IS 'NULL indicates the formation is unnamed.';
COMMENT ON COLUMN climb.formations.geom IS 'Optional geographic location in WGS84. NULL indicates the location is not recorded.';
COMMENT ON CONSTRAINT at_most_one_parent ON climb.formations IS 'A formation may belong to at most one parent (region, crag, or sector). A formation with no parent is valid; this is common before a crag gets well-established.';

INSERT INTO climb.regions (id, slug, name, description)
    SELECT id, slug, name, description FROM reverted_areas WHERE kind = 'region';
INSERT INTO climb.crags (id, slug, name, description, region_id)
    SELECT id, slug, name, description, parent_id FROM reverted_areas WHERE kind = 'crag';
INSERT INTO climb.sectors (id, slug, name, description, crag_id)
    SELECT id, slug, name, description, parent_id FROM reverted_areas WHERE kind = 'sector';
INSERT INTO climb.formations (id, slug, name, description, geom, region_id, crag_id, sector_id)
    SELECT
        f.id, f.slug, f.name, f.description, f.geom,
        CASE WHEN p.kind = 'region' THEN f.parent_id END,
        CASE WHEN p.kind = 'crag' THEN f.parent_id END,
        CASE WHEN p.kind = 'sector' THEN f.parent_id END
    FROM reverted_areas f
    LEFT JOIN reverted_areas p ON p.id = f.parent_id
    WHERE f.kind = 'formation';

ALTER TABLE climb.climbs
    ADD COLUMN region_id UUID REFERENCES climb.regions(id),
    ADD COLUMN crag_id UUID REFERENCES climb.crags(id),
    ADD COLUMN sector_id UUID REFERENCES climb.sectors(id),
    ADD COLUMN formation_id UUID REFERENCES climb.formations(id),
    ADD CONSTRAINT at_most_one_parent CHECK ( num_nonnulls(region_id, crag_id, sector_id, formation_id) < 2 );

UPDATE climb.climbs c
    SET
        region_id = CASE WHEN a.kind = 'region' THEN a.id END,
        crag_id = CASE WHEN a.kind = 'crag' THEN a.id END,
        sector_id = CASE WHEN a.kind = 'sector' THEN a.id END,
        formation_id = CASE WHEN a.kind = 'formation' THEN a.id END
    FROM reverted_areas a
    WHERE a.id = c.area_id;

DROP INDEX climb.climbs_slug_key;
ALTER TABLE climb.climbs
    DROP COLUMN area_id,
    ADD CONSTRAINT climbs_slug_key UNIQUE (slug);

COMMENT ON COLUMN climb.climbs.slug IS 'User-facing identifier that hides the internal UUID from clients. NULL means the climb is not reachable via slug-based lookup.';
COMMENT ON CONSTRAINT at_most_one_parent ON climb.climbs IS 'A climb may belong to at most one parent (region, crag, sector, or formation). A climb with no parent is valid, usually for a climb where its location is not known.';

DROP TABLE climb.areas;
DROP FUNCTION climb.areas_prevent_cycle();

COMMIT;
