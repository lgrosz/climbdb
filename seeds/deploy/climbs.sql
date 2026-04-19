-- Deploy climbdb-seeds:climbs to pg
-- requires: climbdb:climb/climbs
-- requires: formations

BEGIN;

INSERT INTO climb.climbs (
    name,
    description,
    grade,
    formation_id,
    slug
) VALUES (
    'Atomic Decay',
    'Sit start, matched in the undercling-crack. Follow the rails out the '
    'shelf, then up the arete.',
    'V7',
    (
        SELECT id
        FROM climb.formations
        WHERE slug = 'atomic-boulder'
    ),
    'atomic-decay'
);

COMMIT;
