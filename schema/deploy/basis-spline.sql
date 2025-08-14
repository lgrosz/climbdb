-- Deploy climbdb:basis-spline to pg

BEGIN;

CREATE TYPE basis_spline AS (
    degree INT,
    knots FLOAT[],
    points point[]
);

COMMIT;
