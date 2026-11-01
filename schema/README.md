This directory contains a Sqitch project for database schema

## Plans

sqitch.plan
: General schema (default).

## Snapshot

`schema.sql` shows the current schema in one place. It is generated from the
plan, so it is for reading only: nothing deploys from it, and if it disagrees
with the plan then the snapshot is wrong.

After changing the plan, run `scripts/dump-schema.sh` and commit the result with
your change. CI fails if the snapshot is out of date.

