-- Revert climb-pg:yds-letter-enum from pg

BEGIN;

DROP TYPE yds_letter;

COMMIT;
