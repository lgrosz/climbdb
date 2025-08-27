-- Verify climbdb-seeds:formations on pg

BEGIN;

SELECT ref, formation_id
    FROM formation_seed_refs
    WHERE false;

SELECT has_function_privilege('formation_seed_ref(text)', 'execute');

SELECT 1/COUNT(*) FROM formation_seed_ref('atomic-boulder');

ROLLBACK;
