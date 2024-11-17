-- Deploy climb-pg:images to pg

BEGIN;

CREATE TABLE images(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
);

COMMIT;
