-- Deploy climbdb:topo-path-features to pg
-- requires: topos
-- requires: basis-spline

BEGIN;

CREATE TABLE topo_path_features(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    geometry basis_spline NOT NULL,
    climb_id INTEGER NOT NULL REFERENCES climbs(id) ON DELETE CASCADE,
    topo_id INTEGER NOT NULL REFERENCES topos(id) ON DELETE CASCADE
);

COMMIT;
