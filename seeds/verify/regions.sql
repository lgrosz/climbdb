-- Verify climbdb-seeds:refs on pg

BEGIN;

SELECT ref, region_id
    FROM region_seed_refs
    WHERE false;

SELECT has_function_privilege('region_seed_ref(text)', 'execute');

SELECT 1/COUNT(*) FROM region_seed_ref('mount-rushmore');

ROLLBACK;
