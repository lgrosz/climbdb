-- Revert climbdb:climb/ascent-members from pg

BEGIN;

DROP TABLE climb.ascent_members;

COMMIT;
