-- Revert climbdb-seeds:refs from pg

BEGIN;

DELETE FROM climb.sectors
    WHERE id IN (SELECT sector_id FROM sector_seed_refs);

DROP FUNCTION sector_seed_ref(TEXT);
DROP TABLE sector_seed_refs;

COMMIT;
