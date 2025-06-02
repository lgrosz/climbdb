-- Revert climb-pg:basis-spline from pg

BEGIN;

DROP TYPE basis_spline;

COMMIT;
