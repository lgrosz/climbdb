-- Revert climb-pg:ascent-party-members from pg

BEGIN;

DROP TABLE ascent_party_members;

COMMIT;
