-- Verify climb-pg:climbers on pg

BEGIN;

SELECT id, first_name, last_name
    FROM climbers
    WHERE FALSE;

ROLLBACK;
