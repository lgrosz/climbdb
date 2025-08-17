-- Verify climbdb:postgis on pg

BEGIN;

SELECT 1/count(*) FROM pg_extension
    WHERE extname = 'postgis' AND extversion = '3.5.3';

ROLLBACK;
