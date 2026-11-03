BEGIN;

INSERT INTO climb.areas (slug, name, description) VALUES (
    'mount-rushmore',
    'Mount Rushmore',
    'Mount Rushmore is located along SD-244 near Keystone. '
    'The climbing is on fine-grained granite, known for its technical face climbing on small edges and crystals. '
    'Routes are found on the cliffs and spires surrounding the memorial, many of them close to the road. '
    'The area lies mostly within Mount Rushmore National Memorial, managed by the National Park Service.'
);

INSERT INTO climb.areas (slug, name, description, parent_id)
SELECT
    'emancipation',
    'Emancipation Rockphormation',
    'The valley on the backside of the faces. Extends northeast from the road nearly 500 yards.',
    id
FROM climb.areas WHERE slug = 'mount-rushmore';

INSERT INTO climb.areas (slug, name, description, parent_id)
SELECT
    'manhattan',
    'Manhattan',
    'Comprised of the talus field below the main formation and Dire Spire.',
    id
FROM climb.areas WHERE slug = 'emancipation';

INSERT INTO climb.areas (slug, name, description, parent_id)
SELECT
    'atomic-boulder',
    'Atomic Boulder',
    'A generally featured, unsuspecting boulder located near the center of the talus field.',
    id
FROM climb.areas WHERE slug = 'manhattan';

INSERT INTO climb.climbs (slug, name, description, grade, area_id)
SELECT
    'atomic-decay',
    'Atomic Decay',
    'Sit start, matched in the undercling-crack. Follow the rails out the shelf, then up the arete.',
    'V7',
    id
FROM climb.areas WHERE slug = 'atomic-boulder';

INSERT INTO climb.climbers (slug, first_name, last_name) VALUES
    ('josh-dreher', 'Josh', 'Dreher');

WITH atomic_decay_fa AS (
    INSERT INTO climb.ascents (climb_id, ascent_window, first_ascent)
    SELECT id, '[2009-06-01,2009-07-01)'::daterange, TRUE
    FROM climb.climbs WHERE slug = 'atomic-decay'
    RETURNING id
)
INSERT INTO climb.ascent_members (ascent_id, climber_id)
SELECT
    (SELECT id FROM atomic_decay_fa),
    (SELECT id FROM climb.climbers WHERE slug = 'josh-dreher');

COMMIT;
