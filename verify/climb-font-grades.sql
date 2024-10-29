-- Verify climb-pg:climb-font-grades on pg

BEGIN;

SELECT id, climb_id, value, plus, letter
    FROM climb_font_grades
    WHERE FALSE;

SELECT pg_get_functiondef('check_font_letter()'::regprocedure);

DO $$
BEGIN
    ASSERT (
        SELECT EXISTS (
            SELECT 1
            FROM pg_trigger
            WHERE
                tgname = 'enforce_letter_constraint' AND
                tgrelid = 'climb_font_grades'::regclass AND
                tgfoid = 'check_font_letter'::regproc
        )
    );
END $$;

ROLLBACK;
