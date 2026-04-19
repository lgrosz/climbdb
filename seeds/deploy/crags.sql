-- Deploy climbdb-seeds:refs to pg
-- requires: regions
-- requires: climbdb:climb/crags

BEGIN;

INSERT INTO climb.crags (
    name,
    description,
    region_id,
    slug
) VALUES (
    'Emancipation Rockphormation',
    'The valley on the backside of the faces. Extends northeast from the '
    'road nearly 500 yards.',
    (
        SELECT id
        FROM climb.regions
        WHERE slug = 'mount-rushmore'
    ),
    'emancipation'
);

COMMIT;
