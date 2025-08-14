-- Revert climbdb:s3-image-sources from pg

BEGIN;

DROP TABLE s3_image_sources;

COMMIT;
