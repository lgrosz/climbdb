-- Verify climbdb-seeds:climbs on pg

BEGIN;

SELECT ref, climb_id
    FROM climb_seed_refs
    WHERE false;

SELECT has_function_privilege('climb_seed_ref(text)', 'execute');

SELECT 1/COUNT(*) FROM climb_seed_ref('atomic-decay');

ROLLBACK;
