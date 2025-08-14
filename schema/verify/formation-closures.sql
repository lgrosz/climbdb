-- Verify climbdb:formation-closures on pg

BEGIN;

SELECT formation_id, super_area_id
    FROM formation_super_area_closures
    WHERE FALSE;

SELECT formation_id, super_formation_id
    FROM formation_super_formation_closures
    WHERE FALSE;

SELECT pg_get_functiondef('check_no_formation_super_area_closure()'::regprocedure);
SELECT pg_get_functiondef('check_no_formation_super_formation_closure()'::regprocedure);
SELECT pg_get_functiondef('check_formation_super_formation_closures_cycle()'::regprocedure);

DO $$
BEGIN
    ASSERT (
        SELECT EXISTS (
            SELECT 1
            FROM pg_trigger
            WHERE
                tgname = 'enforce_formation_super_area_closure_mutual_exclusivity' AND
                tgrelid = 'formation_super_area_closures'::regclass AND
                tgfoid = 'check_no_formation_super_formation_closure'::regproc
        )
    );

    ASSERT (
        SELECT EXISTS (
            SELECT 1
            FROM pg_trigger
            WHERE
                tgname = 'enforce_formation_super_formation_closure_mutual_exclusivity' AND
                tgrelid = 'formation_super_formation_closures'::regclass AND
                tgfoid = 'check_no_formation_super_area_closure'::regproc
        )
    );

    ASSERT (
        SELECT EXISTS (
            SELECT 1
            FROM pg_trigger
            WHERE
                tgname = 'prevent_formation_super_formation_closures_cycle' AND
                tgrelid = 'formation_super_formation_closures'::regclass AND
                tgfoid = 'check_formation_super_formation_closures_cycle'::regproc
        )
    );
END $$;

ROLLBACK;
