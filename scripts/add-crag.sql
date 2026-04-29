\echo 'Add a new crag'

\prompt 'Name: ' name
\prompt 'Slug: ' slug

\set region_row `scripts/select.sh :'DBNAME' region -- --prompt="Select region > "`
\set region_id `echo :'region_row' | cut -f1`

BEGIN;

INSERT INTO climb.crags (
  name,
  slug,
  region_id
) VALUES (
  nullif(:'name', ''),
  nullif(:'slug', ''),
  nullif(:'region_id', '')::uuid
) RETURNING *;

\prompt 'Commit? (y/N): ' confirm

\if :confirm
  COMMIT;
\else
  ROLLBACK;
\endif

