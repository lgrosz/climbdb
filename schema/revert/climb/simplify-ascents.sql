-- Revert climbdb:climb/simplify-ascents from pg

BEGIN;

ALTER TABLE climb.ascents ADD COLUMN significance TEXT[] NOT NULL DEFAULT '{}';
ALTER TABLE climb.ascents ADD COLUMN style TEXT[] NOT NULL DEFAULT '{}';
ALTER TABLE climb.ascent_members ADD COLUMN role TEXT[] NOT NULL DEFAULT '{}';

UPDATE climb.ascents
    -- all accepted significance values are reduced to just "first-ascent"
    SET significance = ARRAY['first-ascent']
    WHERE first_ascent;

ALTER TABLE climb.ascents DROP COLUMN first_ascent;

COMMENT ON COLUMN climb.ascents.style IS 'EXPERIMENTAL: Multi-valued ascent style descriptors. Intended to capture how the climb was performed at a high level. This is currently stored as a TEXT[] for flexibility but may be normalized into a dedicated schema in the future. Values should be treated as a controlled vocabulary managed at the application level. Examples: "worked", "flash", "redpoint", "equipped".';
COMMENT ON COLUMN climb.ascents.significance IS 'EXPERIMENTAL: Multi-valued descriptors indicating the historical or contextual significance of the ascent. This captures why an ascent is notable (e.g., firsts, major changes, or milestones). Stored as TEXT[] for flexibility but likely to be normalized in the future. Values should be treated as a controlled vocabulary. Examples: "first-ascent", "first-free-ascent", "second-ascent".';
COMMENT ON COLUMN climb.ascent_members.role IS 'EXPERIMENTAL: Multi-valued descriptors of a participant''s role in the ascent. This is distinct from ascent "style" and applies to individual contributors within the ascent party. Stored as TEXT[] for flexibility but may be normalized later. Values should be treated as a controlled vocabulary. Examples: "leader", "follower", "bolter".';

COMMIT;
