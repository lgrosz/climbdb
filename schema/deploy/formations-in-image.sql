-- Deploy climbdb:formations-in-image to pg
-- requires: climb/formations
-- requires: images

BEGIN;

CREATE TABLE formations_in_image (
    image_id INTEGER NOT NULL REFERENCES images(id) ON DELETE CASCADE,
    formation_id INTEGER NOT NULL REFERENCES formations(id) ON DELETE CASCADE,
    PRIMARY KEY (image_id, formation_id)
);

COMMIT;
