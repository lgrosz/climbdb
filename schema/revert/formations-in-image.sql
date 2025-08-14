-- Revert climbdb:formations-in-image from pg

BEGIN;

DROP TABLE formations_in_image;

COMMIT;
