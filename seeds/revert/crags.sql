-- Revert climbdb-seeds:refs from pg

BEGIN;

DELETE FROM climb.crags
    WHERE slug = 'emancipation';

COMMIT;
