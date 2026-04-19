-- Revert climbdb-seeds:climbs from pg

BEGIN;

DELETE FROM climb.climbs
    WHERE slug = 'atomic-decay';

COMMIT;
