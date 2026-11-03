BEGIN;

TRUNCATE
    climb.ascent_members,
    climb.ascents,
    climb.climbers,
    climb.climbs,
    climb.areas
RESTART IDENTITY CASCADE;

COMMIT;
