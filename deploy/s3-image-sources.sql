-- Deploy climb-pg:s3-image-sources to pg
-- requires: images

BEGIN;

CREATE TABLE s3_image_sources(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    bucket TEXT NOT NULL,
    object TEXT NOT NULL,
    image_id INTEGER REFERENCES images(id) ON DELETE restrict,
    UNIQUE (bucket, object)
);

COMMIT;
