-- Revert climbdb-seeds:refs from pg

BEGIN;

DELETE FROM climb.crags
    WHERE id IN (SELECT crag_id FROM crag_seed_refs);

DROP FUNCTION crag_seed_ref(TEXT);
DROP TABLE crag_seed_refs;

COMMIT;
