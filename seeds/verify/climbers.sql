-- Verify climbdb-seeds:climbers on pg

BEGIN;

SELECT ref, climber_id
    FROM climber_seed_refs
    WHERE false;

SELECT has_function_privilege('climber_seed_ref(text)', 'execute');

SELECT 1/COUNT(*) FROM climber_seed_ref('josh-dreher');

ROLLBACK;
