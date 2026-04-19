-- Revert climbdb-seeds:climbers from pg

BEGIN;

DELETE FROM climb.climbers
    WHERE slug = 'josh-dreher';

COMMIT;
