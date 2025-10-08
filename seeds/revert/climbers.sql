-- Revert climbdb-seeds:climbers from pg

BEGIN;

DELETE FROM climb.climbers
    WHERE id IN (SELECT climber_id FROM climber_seed_refs);

DROP FUNCTION climber_seed_ref(TEXT);
DROP TABLE climber_seed_refs;

COMMIT;
