-- Revert climb-pg:images from pg

BEGIN;

DROP TABLE images;

COMMIT;
