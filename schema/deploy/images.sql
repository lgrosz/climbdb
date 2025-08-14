-- Deploy climbdb:images to pg

BEGIN;

CREATE TABLE images(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    alt TEXT
);

COMMIT;
