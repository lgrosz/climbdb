-- Deploy climbdb-seeds:climbers to pg
-- requires: climbdb:climb/climbers

BEGIN;

INSERT INTO climb.climbers (
    first_name,
    last_name,
    slug
) VALUES (
    'Josh',
    'Dreher',
    'josh-dreher'
);

COMMIT;
