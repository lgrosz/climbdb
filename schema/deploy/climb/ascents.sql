-- Deploy climbdb:climb/ascents to pg
-- requires: climb
-- requires: climb/climbs

BEGIN;

CREATE TABLE climb.ascents (
    id UUID PRIMARY KEY DEFAULT uuidv7(),
    climb_id UUID NOT NULL REFERENCES climb.climbs(id) ON DELETE CASCADE,
    ascent_window DATERANGE,
    description TEXT,
    style TEXT[] NOT NULL DEFAULT '{}',
    significance TEXT[] NOT NULL DEFAULT '{}'
);

COMMENT ON TABLE climb.ascents IS 'Describes an ascent event of a climb';
COMMENT ON COLUMN climb.ascents.ascent_window IS 'Optional date range over which the ascent occurred. NULL indicates the date is unknown. Use a single-day range (e.g., [2026-01-01,2026-01-02)) for a known specific date.';
COMMENT ON COLUMN climb.ascents.style IS 'EXPERIMENTAL: Multi-valued ascent style descriptors. Intended to capture how the climb was performed at a high level. This is currently stored as a TEXT[] for flexibility but may be normalized into a dedicated schema in the future. Values should be treated as a controlled vocabulary managed at the application level. Examples: "worked", "flash", "redpoint", "equipped".';
COMMENT ON COLUMN climb.ascents.significance IS 'EXPERIMENTAL: Multi-valued descriptors indicating the historical or contextual significance of the ascent. This captures why an ascent is notable (e.g., firsts, major changes, or milestones). Stored as TEXT[] for flexibility but likely to be normalized in the future. Values should be treated as a controlled vocabulary. Examples: "first-ascent", "first-free-ascent", "second-ascent".';

COMMIT;
