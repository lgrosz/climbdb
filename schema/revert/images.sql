-- Revert climbdb:images from pg

BEGIN;

DROP TABLE images;

COMMIT;
