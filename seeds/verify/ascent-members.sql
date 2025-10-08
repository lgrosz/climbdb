-- Verify climbdb-seeds:ascent-members on pg

BEGIN;

SELECT ref, ascent_id, climber_id
    FROM ascent_member_seed_refs
    WHERE false;

SELECT has_function_privilege('ascent_member_seed_ref(text)', 'execute');

SELECT 1/COUNT(*) FROM ascent_member_seed_ref('atomic-decay-fa-josh-dreher');

ROLLBACK;
