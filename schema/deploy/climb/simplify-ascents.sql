-- Deploy climbdb:climb/simplify-ascents to pg
-- requires: climb
-- requires: climb/ascents
-- requires: climb/ascent-members

BEGIN;

-- Refuse to deploy if any of the dropped columns hold irreducible data
DO $$
DECLARE
    unexpected TEXT[];
BEGIN
    SELECT array_agg(DISTINCT s)
        INTO unexpected
        FROM climb.ascents, unnest(significance) AS s
        WHERE s IS NULL OR s <> ALL (ARRAY['first-ascent', 'fa']);

    IF unexpected IS NOT NULL THEN
        RAISE EXCEPTION 'cannot reduce significance to first_ascent: % would be lost', unexpected
            USING HINT = 'Record these in climb.ascents.description, clear them from significance, then deploy again.';
    END IF;

    SELECT array_agg(DISTINCT s)
        INTO unexpected
        FROM climb.ascents, unnest(style) AS s;

    IF unexpected IS NOT NULL THEN
        RAISE EXCEPTION 'cannot drop style: % would be lost', unexpected
            USING HINT = 'Record these in climb.ascents.description, clear the column, then deploy again.';
    END IF;

    SELECT array_agg(DISTINCT r)
        INTO unexpected
        FROM climb.ascent_members, unnest(role) AS r;

    IF unexpected IS NOT NULL THEN
        RAISE EXCEPTION 'cannot drop role: % would be lost', unexpected
            USING HINT = 'Record these in the description of the ascent, clear the column, then deploy again.';
    END IF;
END
$$;

ALTER TABLE climb.ascents
    ADD COLUMN first_ascent BOOLEAN NOT NULL DEFAULT FALSE;

UPDATE climb.ascents
    SET first_ascent = TRUE
    WHERE significance && ARRAY['first-ascent', 'fa'];

ALTER TABLE climb.ascents DROP COLUMN significance;

COMMENT ON COLUMN climb.ascents.first_ascent IS 'Whether this ascent was the first ascent of the climb.';

ALTER TABLE climb.ascents DROP COLUMN style;
ALTER TABLE climb.ascent_members DROP COLUMN role;

COMMIT;
