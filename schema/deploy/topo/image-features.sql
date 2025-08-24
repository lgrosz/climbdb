-- Deploy climbdb:topo/image-features to pg
-- requires: media/images
-- requires: topo/topos

BEGIN;

CREATE TABLE topo.image_features(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_crop box,
    dest_crop box NOT NULL,
    image_id INTEGER NOT NULL REFERENCES media.images(id),
    topo_id INTEGER NOT NULL REFERENCES topo.topos(id) ON DELETE CASCADE
);

COMMIT;
