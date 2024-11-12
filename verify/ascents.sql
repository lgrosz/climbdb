-- Verify climb-pg:ascents on pg

BEGIN;

SELECT id, climb_id, date_window
    FROM ascents
    WHERE FALSE;

ROLLBACK;
