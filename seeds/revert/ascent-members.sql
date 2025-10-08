-- Revert climbdb-seeds:ascent-members from pg

BEGIN;

DELETE FROM climb.ascent_members am
WHERE (am.ascent_id, am.climber_id) IN (
    SELECT r.ascent_id, r.climber_id
    FROM ascent_member_seed_refs r
);

DROP FUNCTION ascent_member_seed_ref(TEXT);
DROP TABLE ascent_member_seed_refs;

COMMIT;
