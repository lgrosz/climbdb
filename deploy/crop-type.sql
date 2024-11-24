-- Deploy climb-pg:crop-type to pg

BEGIN;

CREATE TYPE crop AS(
    x DOUBLE PRECISION,
    y DOUBLE PRECISION,
    w DOUBLE PRECISION,
    h DOUBLE PRECISION
);

COMMIT;
