-- Verify climbdb-seeds:climbers on pg

BEGIN;

SELECT 1/COUNT(*)
    FROM climb.climbers
    WHERE slug ='josh-dreher';

ROLLBACK;
