-- Revert climbdb:climb/formations-in-image from pg

BEGIN;

DROP TABLE climb.formations_in_image;

COMMIT;
