-- Revert climbdb-seeds:formations from pg

BEGIN;

DELETE FROM climb.formations
    WHERE slug = 'atomic-boulder';

COMMIT;
