-- Verify climbdb:ascents on pg

BEGIN;

SELECT id, ascent_window, ascent_duration, members_incomplete
    FROM climb.ascents
    WHERE FALSE;

ROLLBACK;
