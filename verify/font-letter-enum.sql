-- Verify climb-pg:font-letter-enum on pg

BEGIN;

DO $$
BEGIN
    ASSERT (
        SELECT EXISTS (
            SELECT 1
            FROM pg_type
            WHERE typname = 'font_letter'
        )
    );
END $$;

ROLLBACK;
