-- Revert climbdb-seeds:refs from pg

BEGIN;

DELETE FROM climb.sectors
    WHERE slug = 'manhattan';

COMMIT;
