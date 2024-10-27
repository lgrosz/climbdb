-- Deploy climb-pg:yds-letter-enum to pg

BEGIN;

CREATE TYPE yds_letter AS ENUM ('a', 'b', 'c', 'd');

COMMIT;
