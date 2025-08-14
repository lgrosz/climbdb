-- Verify climbdb:area-closures on pg

BEGIN;

SELECT area_id, super_area_id
    FROM area_closures
    WHERE FALSE;

SELECT pg_get_functiondef('check_area_closures_cycle()'::regprocedure);

DO $$
BEGIN
    ASSERT (
        SELECT EXISTS (
            SELECT 1
            FROM pg_trigger
            WHERE
                tgname = 'prevent_area_closures_cycle' AND
                tgrelid = 'area_closures'::regclass AND
                tgfoid = 'check_area_closures_cycle'::regproc
        )
    );
END $$;

ROLLBACK;
