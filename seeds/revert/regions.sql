-- Revert climbdb-seeds:refs from pg

BEGIN;

DELETE FROM climb.regions
    WHERE id IN (SELECT region_id FROM region_seed_refs);

DROP FUNCTION region_seed_ref(TEXT);
DROP TABLE region_seed_refs;

COMMIT;
