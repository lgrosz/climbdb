-- Verify climb-pg:climb-closures on pg

BEGIN;

SELECT climb_id, super_area_id
    FROM climb_super_area_closures
    WHERE FALSE;

SELECT climb_id, super_formation_id
    FROM climb_super_formation_closures
    WHERE FALSE;

SELECT pg_get_functiondef('check_no_climb_super_area_closure()'::regprocedure);
SELECT pg_get_functiondef('check_no_climb_super_formation_closure()'::regprocedure);

DO $$
BEGIN
    ASSERT (
        SELECT EXISTS (
            SELECT 1
            FROM pg_trigger
            WHERE
                tgname = 'enforce_climb_super_area_closure_mutual_exclusivity' AND
                tgrelid = 'climb_super_area_closures'::regclass AND
                tgfoid = 'check_no_climb_super_formation_closure'::regproc
        )
    );

    ASSERT (
        SELECT EXISTS (
            SELECT 1
            FROM pg_trigger
            WHERE
                tgname = 'enforce_climb_super_formation_closure_mutual_exclusivity' AND
                tgrelid = 'climb_super_formation_closures'::regclass AND
                tgfoid = 'check_no_climb_super_area_closure'::regproc
        )
    );
END $$;

ROLLBACK;
