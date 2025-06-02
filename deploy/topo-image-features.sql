-- Deploy climb-pg:topo-image-features to pg
-- requires: images
-- requires: topos

BEGIN;

CREATE TABLE topo_image_features(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_crop box,
    dest_crop box NOT NULL,
    image_id INTEGER NOT NULL REFERENCES images(id),
    topo_id INTEGER NOT NULL REFERENCES topos(id) ON DELETE CASCADE
);

COMMIT;
