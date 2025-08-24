-- Verify climbdb:topo on pg

BEGIN;

SELECT pg_catalog.has_schema_privilege('topo', 'usage');

ROLLBACK;
