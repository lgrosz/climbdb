-- Verify climb-pg:valid-basis-spline on pg

BEGIN;

SELECT pg_get_functiondef('validate_basis_spline(basis_spline)'::regprocedure);

SELECT typname
    FROM pg_type
    WHERE typname = 'valid_basis_spline';


ROLLBACK;
