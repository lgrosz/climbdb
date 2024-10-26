-- Deploy climb-pg:font-letter-enum to pg

BEGIN;

CREATE TYPE font_letter AS ENUM ('A', 'B', 'C');

COMMIT;
