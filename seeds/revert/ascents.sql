-- Revert climbdb-seeds:ascents from pg

BEGIN;

DELETE FROM climb.ascents
    WHERE id IN (SELECT ascent_id FROM ascent_seed_refs);

DROP FUNCTION ascent_seed_ref(TEXT);
DROP TABLE ascent_seed_refs;

COMMIT;
