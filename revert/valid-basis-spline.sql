-- Revert climb-pg:valid-basis-spline from pg

BEGIN;

DROP DOMAIN valid_basis_spline;
DROP FUNCTION validate_basis_spline(basis_spline);

COMMIT;
