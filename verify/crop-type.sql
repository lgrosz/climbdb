-- Verify climb-pg:crop-type on pg

BEGIN;

SELECT 1/count(*) FROM pg_type WHERE typname = 'crop';

ROLLBACK;
