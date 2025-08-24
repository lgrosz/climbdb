-- Deploy climbdb:topo/topos to pg

BEGIN;

CREATE TABLE topo.topos(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    title TEXT,
    width DOUBLE PRECISION NOT NULL,
    height DOUBLE PRECISION NOT NULL
);

COMMENT ON TABLE topo.topos IS 'Describes topos and their dimensions.';

COMMIT;
