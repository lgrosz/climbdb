-- Deploy climb-pg:valid-basis-spline to pg
-- requires: basis-spline

BEGIN;

CREATE FUNCTION validate_basis_spline(spline basis_spline)
RETURNS boolean AS $$
DECLARE
    num_knots INT;
    num_pts INT;
    i INT;
BEGIN
    -- constraints cannot be included in composite types
    IF spline.degree IS NULL OR spline.knots IS NULL OR spline.points IS NULL THEN
        RETURN false;
    END IF;

    num_knots := array_length(spline.knots, 1);
    num_pts := array_length(spline.points, 1);

    -- can be null as the dimension of an empty array is unknown
    IF num_knots IS NULL OR num_pts IS NULL THEN
        RETURN false;
    END IF;

    IF spline.degree < 1 THEN
        RETURN false;
    END IF;

    -- TODO I think this leaves room for error.. may need to
    -- - check array definition
    -- - check knot dimension against definition
    -- #knots = #pts + degree + 1
    IF num_knots != num_pts + spline.degree + 1 THEN
        RETURN false;
    END IF;

    -- check for monotonicity
    IF EXISTS (
        SELECT 1
        FROM generate_subscripts(spline.knots, 1) AS idx
        WHERE idx < array_length(spline.knots, 1)
          AND spline.knots[idx] > spline.knots[idx + 1]
    ) THEN
        RETURN false;
    END IF;

    -- TODO use generate_subscripts
    FOR i IN 1 .. num_pts LOOP
        IF spline.points[i] IS NULL THEN
            RETURN false;
        END IF;
    END LOOP;

    RETURN true;
END;
$$ LANGUAGE plpgsql IMMUTABLE STRICT;

CREATE DOMAIN valid_basis_spline AS basis_spline
    CHECK (validate_basis_spline(VALUE));


COMMIT;
