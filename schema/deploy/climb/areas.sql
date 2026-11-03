-- Deploy climbdb:climb/areas to pg
-- requires: climb
-- requires: postgis
-- requires: climb/regions
-- requires: climb/crags
-- requires: climb/sectors
-- requires: climb/formations
-- requires: climb/climbs

BEGIN;

CREATE TABLE climb.areas (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    parent_id UUID REFERENCES climb.areas(id),
    slug TEXT,
    name TEXT,
    description TEXT,
    geom geometry(Geometry, 4326)
);

-- Slugs are optional, so NULL slugs never conflict; NULL parents do, which makes
-- root areas siblings of one another.
CREATE UNIQUE INDEX areas_slug_key ON climb.areas (parent_id, slug) NULLS NOT DISTINCT
    WHERE slug IS NOT NULL;
CREATE INDEX areas_parent_id_idx ON climb.areas (parent_id);

COMMENT ON TABLE climb.areas IS 'A place, at any scale: from a large region down to a single boulder. Areas nest to any depth. What an area is called, and how it is presented, is left to clients.';
COMMENT ON COLUMN climb.areas.parent_id IS 'The area containing this one. NULL means this is a root area.';
COMMENT ON COLUMN climb.areas.slug IS 'User-facing identifier that hides the internal UUID from clients. Unique among siblings, so an area is addressed by its path. NULL means the area is not reachable via slug-based lookup.';
COMMENT ON COLUMN climb.areas.name IS 'NULL indicates the area is unnamed.';
COMMENT ON COLUMN climb.areas.geom IS 'Optional geographic location in WGS84. NULL indicates the location is not recorded.';

-- Parents are always inserted before their children, satisfying the foreign key.
INSERT INTO climb.areas (id, parent_id, slug, name, description)
    SELECT id, NULL, slug, name, description FROM climb.regions;
INSERT INTO climb.areas (id, parent_id, slug, name, description)
    SELECT id, region_id, slug, name, description FROM climb.crags;
INSERT INTO climb.areas (id, parent_id, slug, name, description)
    SELECT id, crag_id, slug, name, description FROM climb.sectors;
INSERT INTO climb.areas (id, parent_id, slug, name, description, geom)
    SELECT id, COALESCE(sector_id, crag_id, region_id), slug, name, description, geom
    FROM climb.formations;

ALTER TABLE climb.climbs ADD COLUMN area_id UUID REFERENCES climb.areas(id);

-- at_most_one_parent guarantees that this discards nothing
UPDATE climb.climbs
    SET area_id = COALESCE(formation_id, sector_id, crag_id, region_id);

ALTER TABLE climb.climbs
    DROP CONSTRAINT at_most_one_parent,
    DROP CONSTRAINT climbs_slug_key,
    DROP COLUMN region_id,
    DROP COLUMN crag_id,
    DROP COLUMN sector_id,
    DROP COLUMN formation_id;

CREATE UNIQUE INDEX climbs_slug_key ON climb.climbs (area_id, slug) NULLS NOT DISTINCT
    WHERE slug IS NOT NULL;
CREATE INDEX climbs_area_id_idx ON climb.climbs (area_id);

COMMENT ON COLUMN climb.climbs.area_id IS 'The area containing this climb. NULL is valid, usually for a climb where its location is not known.';
COMMENT ON COLUMN climb.climbs.slug IS 'User-facing identifier that hides the internal UUID from clients. Unique within an area, so a climb is addressed by its path. NULL means the climb is not reachable via slug-based lookup.';

DROP TABLE climb.formations;
DROP TABLE climb.sectors;
DROP TABLE climb.crags;
DROP TABLE climb.regions;

CREATE FUNCTION climb.areas_prevent_cycle() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
    IF NEW.parent_id IS NULL THEN
        RETURN NEW;
    END IF;

    -- Two concurrent moves could each pass this check and form a cycle together
    PERFORM pg_advisory_xact_lock(hashtext('climb.areas.parent_id'));

    IF EXISTS (
        WITH RECURSIVE ancestors AS (
            SELECT NEW.parent_id AS id
            UNION
            SELECT a.parent_id
                FROM climb.areas a
                JOIN ancestors ON a.id = ancestors.id
                WHERE a.parent_id IS NOT NULL
        )
        SELECT FROM ancestors WHERE id = NEW.id
    ) THEN
        RAISE EXCEPTION 'area % cannot be placed beneath itself', NEW.id
            USING ERRCODE = 'check_violation';
    END IF;

    RETURN NEW;
END
$$;

COMMENT ON FUNCTION climb.areas_prevent_cycle() IS 'Keeps climb.areas a tree by rejecting a parent that is the area itself or one of its descendants.';

CREATE TRIGGER prevent_cycle
    BEFORE INSERT OR UPDATE OF id, parent_id ON climb.areas
    FOR EACH ROW EXECUTE FUNCTION climb.areas_prevent_cycle();

COMMIT;
