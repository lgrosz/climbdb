-- Verify climbdb:climb/simplify-ascents on pg

BEGIN;

SELECT first_ascent
    FROM climb.ascents
    WHERE FALSE;

DO $$
BEGIN
    IF EXISTS (
        SELECT FROM pg_attribute
        WHERE attrelid IN ('climb.ascents'::regclass, 'climb.ascent_members'::regclass)
          AND attname IN ('significance', 'style', 'role')
          AND NOT attisdropped
    ) THEN
        RAISE EXCEPTION 'significance, style, and role should have been dropped';
    END IF;
END
$$;

ROLLBACK;
