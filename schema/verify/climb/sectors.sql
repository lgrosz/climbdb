-- Verify climbdb:climb/sectors on pg

BEGIN;

SELECT id, slug, name, description, crag_id
    FROM climb.sectors
    WHERE FALSE;

ROLLBACK;
