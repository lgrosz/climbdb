-- Verify climbdb:climb/crags on pg

BEGIN;

SELECT id, name
    FROM climb.crags
    WHERE FALSE;

ROLLBACK;
