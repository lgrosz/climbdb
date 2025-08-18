-- Verify climbdb:ascent-members on pg

BEGIN;

SELECT ascent_id, climber_id
    FROM climb.ascent_members
    WHERE FALSE;

ROLLBACK;
