-- Verify climbdb-seeds:refs on pg

BEGIN;

SELECT 1/COUNT(*)
    FROM climb.crags
    WHERE slug = 'emancipation';

ROLLBACK;
