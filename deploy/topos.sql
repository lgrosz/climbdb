-- Deploy climb-pg:topos to pg
-- requires: images
-- requires: crop-type

BEGIN;

CREATE TABLE topos(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    image_id INTEGER NOT NULL REFERENCES images(id) ON DELETE CASCADE,
    crop CROP
);

COMMIT;
