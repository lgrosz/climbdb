-- Revert climb-pg:font-letter-enum from pg

BEGIN;

DROP TYPE font_letter;

COMMIT;
