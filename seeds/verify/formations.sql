-- Verify climbdb-seeds:formations on pg

BEGIN;

SELECT 1/COUNT(*)
    FROM climb.formations
    WHERE slug = 'atomic-boulder';

ROLLBACK;
