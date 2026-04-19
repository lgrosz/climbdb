-- Verify climbdb-seeds:climbs on pg

BEGIN;

SELECT 1/COUNT(*)
    FROM climb.climbs
    WHERE slug ='atomic-decay';

ROLLBACK;
