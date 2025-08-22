-- Revert climbdb:media from pg

BEGIN;

DROP SCHEMA media;

COMMIT;
