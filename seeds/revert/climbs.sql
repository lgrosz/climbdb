-- Revert climbdb-seeds:climbs from pg

BEGIN;

DELETE FROM climb.climbs
    WHERE id IN (SELECT climb_id FROM climb_seed_refs);

DROP FUNCTION climb_seed_ref(TEXT);
DROP TABLE climb_seed_refs;

COMMIT;
