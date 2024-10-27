-- Verify climb-pg:yds-letter-enum on pg

BEGIN;

DO $$
BEGIN
    ASSERT (
        SELECT EXISTS (
            SELECT 1
            FROM pg_type
            WHERE typname = 'yds_letter'
        )
    );
END $$;

ROLLBACK;
