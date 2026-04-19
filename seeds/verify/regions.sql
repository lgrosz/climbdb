-- Verify climbdb-seeds:refs on pg

BEGIN;

SELECT 1/COUNT(*)
    FROM climb.regions 
    WHERE slug = 'mount-rushmore';

ROLLBACK;
