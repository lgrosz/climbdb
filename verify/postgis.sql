-- Verify climb-pg:postgis on pg

BEGIN;

SELECT 1/count(*) FROM pg_extension WHERE extname = 'postgis';

ROLLBACK;
