-- Verify climbdb-seeds:ascents on pg

BEGIN;

SELECT ref, ascent_id
    FROM ascent_seed_refs
    WHERE false;

SELECT has_function_privilege('ascent_seed_ref(text)', 'execute');

SELECT 1/COUNT(*) FROM ascent_seed_ref('atomic-decay-fa');

ROLLBACK;
