-- Deploy climbdb-seeds:ascent-members to pg
-- requires: climbers
-- requires: ascents
-- requires: climbdb:climb/ascent-members

BEGIN;

CREATE TABLE ascent_member_seed_refs (
    ref TEXT PRIMARY KEY,
    ascent_id UUID NOT NULL,
    climber_id UUID NOT NULL,
    FOREIGN KEY (ascent_id, climber_id)
        REFERENCES climb.ascent_members(ascent_id, climber_id)
        ON DELETE CASCADE
);

CREATE FUNCTION ascent_member_seed_ref(p_ref TEXT)
RETURNS TABLE(ref TEXT, ascent_id UUID, climber_id UUID) LANGUAGE sql STABLE AS $$
    SELECT ref, ascent_id, climber_id
    FROM ascent_member_seed_refs
    WHERE ref = p_ref;
$$;

WITH last_ascent_member AS (
    INSERT INTO climb.ascent_members (
        ascent_id,
        climber_id
    ) VALUES (
        (SELECT ascent_id FROM ascent_seed_ref('atomic-decay-fa')),
        (SELECT id FROM climb.climbers WHERE slug = 'josh-dreher')
    ) RETURNING ascent_id, climber_id
) INSERT INTO ascent_member_seed_refs (ref, ascent_id, climber_id)
    SELECT 'atomic-decay-fa-josh-dreher', ascent_id, climber_id FROM last_ascent_member;

COMMIT;
