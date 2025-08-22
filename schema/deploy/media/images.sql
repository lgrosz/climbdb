-- Deploy climbdb:media/images to pg

BEGIN;

CREATE TABLE media.images(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    alt TEXT
);

COMMIT;
