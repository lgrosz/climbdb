-- Deploy climbdb-seeds:formations to pg
-- requires: sectors
-- requires: climbdb:climb/formations

BEGIN;

INSERT INTO climb.formations (
    name,
    description,
    sector_id,
    slug
) VALUES (
    'Atomic Boulder',
    'A generally featured, unsuspecting boulder located near the center of '
    'the talus field.',
    (
        SELECT id
        FROM climb.sectors
        WHERE slug = 'manhattan'
    ),
    'atomic-boulder'
);

COMMIT;
