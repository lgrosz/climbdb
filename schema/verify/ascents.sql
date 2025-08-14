-- Verify climbdb:ascents on pg

BEGIN;

SELECT id, climb_id, climber_id, date_window
    FROM ascents
    WHERE FALSE;

ROLLBACK;
