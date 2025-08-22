-- Verify climbdb:media on pg

BEGIN;

SELECT pg_catalog.has_schema_privilege('media', 'usage');

ROLLBACK;
