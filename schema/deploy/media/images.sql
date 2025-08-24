-- Deploy climbdb:media/images to pg

BEGIN;

CREATE TABLE media.images(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    alt TEXT
);

COMMENT ON TABLE media.images IS 'Describes images. These are abstract and there is no opinion on how they are stored.';

COMMIT;
