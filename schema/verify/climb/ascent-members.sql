-- Verify climbdb:climb/ascent-members on pg

BEGIN;

SELECT ascent_id, climber_id, role
    FROM climb.ascent_members
    WHERE FALSE;

ROLLBACK;
