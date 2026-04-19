-- Deploy climbdb-seeds:refs to pg
-- requires: climbdb:climb/regions

BEGIN;

INSERT INTO climb.regions (
    name,
    description,
    slug
) VALUES (
    'Mount Rushmore',
    'Mount Rushmore is located along SD-244 near Keystone. '
    'The climbing is on fine-grained granite, known for its technical face climbing on small edges and crystals. '
    'Routes are found on the cliffs and spires surrounding the memorial, many of them close to the road. '
    'The area lies mostly within Mount Rushmore National Memorial, managed by the National Park Service.',
    'mount-rushmore'
);

COMMIT;
