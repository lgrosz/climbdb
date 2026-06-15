-- Verify climbdb:climb/ascents on pg

BEGIN;

SELECT id, climb_id, ascent_window, description
    FROM climb.ascents
    WHERE FALSE;

ROLLBACK;
