-- Deploy climbdb-seeds:refs to pg
-- requires: crags
-- requires: climbdb:climb/sectors

BEGIN;

INSERT INTO climb.sectors (
    name,
    description,
    crag_id,
    slug
) VALUES (
    'Manhattan',
    'Comprised of the talus field below the main formation and Dire Spire.',
    (
        SELECT id
        FROM climb.crags
        WHERE slug ='emancipation'
    ),
    'manhattan'
);

COMMIT;
