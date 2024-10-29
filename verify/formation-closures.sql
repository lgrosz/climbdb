-- Verify climb-pg:formation-closures on pg

BEGIN;

SELECT formation_id, super_formation_id, super_area_id
    FROM formation_closures
    WHERE FALSE;

select pg_get_functiondef('check_formation_closures_cycle()'::regprocedure);

DO $$
BEGIN
    ASSERT (
        SELECT EXISTS (
            SELECT 1
            FROM pg_trigger
            WHERE
                tgname = 'prevent_formation_closures_cycle' AND
                tgrelid = 'formation_closures'::regclass AND
                tgfoid = 'check_formation_closures_cycle'::regproc
        )
    );
END $$;

ROLLBACK;
