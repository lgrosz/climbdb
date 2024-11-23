-- Deploy climb-pg:climb-topo-splines to pg
-- require: climbs
-- require: topos

BEGIN;

-- The splines indicate a path for the respective climb.
-- ```json
-- [
--   [ { "x": 0.0, "y": 0.0 }, { "x": 0.5, "y": 0.5 } ],
--   [ { "x": 0.6, "y": 0.6 }, { "x": 0.7, "y": 0.9 } ]
-- ]
-- ```
CREATE TABLE climb_topo_splines(
    climb_id INTEGER NOT NULL REFERENCES climbs(id) ON DELETE CASCADE,
    topo_id INTEGER NOT NULL REFERENCES topos(id) ON DELETE CASCADE,
    PRIMARY KEY(climb_id, topo_id),
    splines JSONB
);

COMMIT;
