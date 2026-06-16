-- Revert climbdb:climb/rank from pg

BEGIN;

ALTER TABLE climb.crags DROP COLUMN rank;
ALTER TABLE climb.sectors DROP COLUMN rank;
ALTER TABLE climb.formations DROP COLUMN rank;
ALTER TABLE climb.climbs DROP COLUMN rank;

COMMIT;
