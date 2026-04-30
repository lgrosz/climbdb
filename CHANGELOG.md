# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- `climb` PostgreSQL schema containing all database objects.
- `climb.regions` table for large geographic or administrative areas.
- `climb.crags` table for distinct climbing areas.
- `climb.sectors` table for subdivisions of a crag, used to organize formations and climbs within large crags.
- `climb.formations` table for distinct geological features.
- `climb.climbs` table for climbing routes of any kind.
- `climb.climbers` table for people as climbing participants.
- `climb.ascents` table for ascent events, likely to be used for documenting ascents of significance.
- `climb.ascent_members` table associating climbers with ascents.
- UUID v7 primary keys on all tables via `uuidv7()`.
- `slug` column on all tables as a user-facing identifier that hides internal UUIDs.
- `at_most_one_parent` constraint on `formations` and `climbs` enforcing that an entity belongs to at most one parent.
- PostGIS extension for geometry support. Currently, this is only supported on `climb.formations`.
- Interactive data entry scripts for all entity types (`add-region.sql`, `add-crag.sql`, `add-sector.sql`, `add-formation.sql`, `add-climb.sql`, `add-climber.sql`, `add-ascent.sql`). These should help with seeding the database.
  - `select.sh` - fuzzy selection helper (requires `fzf`) used by data entry scripts.
  - `daterange.sh` - utility to parse common date input formats into PostgreSQL `DATERANGE` literals.
  - `geom.sh` - utility to parse coordinate input formats (including lat/lon with spaces) into PostGIS geometry literals.
- pgTAP test suite covering table structure, column types, constraints, and foreign keys for all tables.
- Bats test suite for `daterange.sh` and `geom.sh` scripts.
- GitHub Actions CI pipeline running pgTAP and Bats tests.

[Unreleased]: https://github.com/lgrosz/climbdb/commits/main/
