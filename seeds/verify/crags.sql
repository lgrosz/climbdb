-- Verify climbdb-seeds:refs on pg

BEGIN;

SELECT ref, crag_id
    FROM crag_seed_refs
    WHERE false;

SELECT has_function_privilege('crag_seed_ref(text)', 'execute');

SELECT 1/COUNT(*) FROM crag_seed_ref('emancipation');

ROLLBACK;
