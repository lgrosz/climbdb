-- Verify climb-pg:climb-ext on pg

BEGIN;

SELECT 1/count(*) FROM pg_extension WHERE extname = 'pg_climb';

ROLLBACK;
