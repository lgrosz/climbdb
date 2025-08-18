-- Verify climbdb:pg-climb on pg

BEGIN;

SELECT 1/count(*) FROM pg_extension
    WHERE extname = 'pg_climb' AND extversion = '1.0';

ROLLBACK;
