-- Revert climbdb-seeds:formations from pg

BEGIN;

DELETE FROM climb.formations
    WHERE id IN (SELECT formation_id FROM formation_seed_refs);

DROP FUNCTION formation_seed_ref(TEXT);
DROP TABLE formation_seed_refs;

COMMIT;
