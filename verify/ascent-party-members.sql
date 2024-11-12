-- Verify climb-pg:ascent-party-members on pg

BEGIN;

SELECT ascent_id, climber_id
    FROM ascent_party_members
    WHERE FALSE;

ROLLBACK;
