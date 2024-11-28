-- Verify climb-pg:s3-image-sources on pg

BEGIN;

SELECT id, bucket, object, image_id
    FROM s3_image_sources;

ROLLBACK;
