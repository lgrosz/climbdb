BEGIN;

TRUNCATE
    climb.ascent_members,
    climb.ascents,
    climb.climbers,
    climb.climbs,
    climb.formations,
    climb.sectors,
    climb.crags,
    climb.regions
RESTART IDENTITY CASCADE;

COMMIT;
