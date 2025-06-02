-- Verify climb-pg:basis-spline on pg

BEGIN;

SELECT typname
    FROM pg_type
    WHERE typname = 'basis_spline';

ROLLBACK;
