-- Verify climbdb:climb/ascents on pg

BEGIN;

SELECT id, climb_id, ascent_window, first_ascent, members_complete, verified
    FROM climb.ascents
    WHERE FALSE;

ROLLBACK;
