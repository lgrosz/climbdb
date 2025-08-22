-- Revert climbdb:media/images from pg

BEGIN;

DROP TABLE media.images;

COMMIT;
