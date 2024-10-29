-- Verify climb-pg:climb-yds-grades on pg

BEGIN;

SELECT id, climb_id, value, letter
    FROM climb_yds_grades
    WHERE FALSE;

SELECT pg_get_functiondef('check_yds_letter()'::regprocedure);

DO $$
BEGIN
    ASSERT (
        SELECT EXISTS (
            SELECT 1
            FROM pg_trigger
            WHERE
                tgname = 'enforce_letter_constraint' AND
                tgrelid = 'climb_yds_grades'::regclass AND
                tgfoid = 'check_yds_letter'::regproc
        )
    );
END $$;

ROLLBACK;
