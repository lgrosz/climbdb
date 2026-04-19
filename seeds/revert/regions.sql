-- Revert climbdb-seeds:refs from pg

BEGIN;

DELETE FROM climb.regions
    WHERE slug = 'mount-rushmore';

COMMIT;
