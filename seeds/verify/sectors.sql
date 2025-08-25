-- Verify climbdb-seeds:refs on pg

BEGIN;

SELECT ref, sector_id
    FROM sector_seed_refs
    WHERE false;

SELECT has_function_privilege('sector_seed_ref(text)', 'execute');

SELECT 1/COUNT(*) FROM sector_seed_ref('manhattan');

ROLLBACK;
