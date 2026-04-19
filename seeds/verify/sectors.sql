-- Verify climbdb-seeds:refs on pg

BEGIN;

SELECT 1/COUNT(*)
    FROM climb.sectors
    WHERE slug = 'manhattan';

ROLLBACK;
