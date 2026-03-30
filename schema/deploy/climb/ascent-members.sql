-- Deploy climbdb:climb/ascent-members to pg
-- requires: climb
-- requires: climb/ascents
-- requires: climb/climbers

BEGIN;

CREATE TABLE climb.ascent_members (
    ascent_id INTEGER NOT NULL REFERENCES climb.ascents(id) ON DELETE CASCADE,
    climber_id INTEGER NOT NULL REFERENCES climb.climbers(id),
    role TEXT[] NOT NULL DEFAULT '{}',
    PRIMARY KEY (ascent_id, climber_id)
);

COMMENT ON TABLE climb.ascent_members IS 'Describes members of an ascent party';
COMMENT ON COLUMN climb.ascent_members.role IS 'EXPERIMENTAL: Multi-valued descriptors of a participant''s role in the ascent. This is distinct from ascent "style" and applies to individual contributors within the ascent party. Stored as TEXT[] for flexibility but may be normalized later. Values should be treated as a controlled vocabulary. Examples: "lead", "follow", "bolter", "developer".';

COMMIT;
