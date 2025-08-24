-- Deploy climbdb:climb/formations-in-image to pg
-- requires: climb/formations
-- requires: media/images

BEGIN;

CREATE TABLE climb.formations_in_image (
    image_id INTEGER NOT NULL REFERENCES media.images(id) ON DELETE CASCADE,
    formation_id INTEGER NOT NULL REFERENCES climb.formations(id) ON DELETE CASCADE,
    PRIMARY KEY (image_id, formation_id)
);

COMMENT ON TABLE climb.formations_in_image IS 'Associates formations to a particular image.';

COMMIT;
