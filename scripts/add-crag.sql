\echo 'Add a new crag'

\prompt 'Name: ' name
\set default_slug `scripts/slug.sh :'name'`
\set slug_prompt 'Slug [' :default_slug ']: '
\prompt :slug_prompt slug
select coalesce(nullif(:'slug', ''), :'default_slug') as slug
\gset

\set region_row `scripts/select.sh :'DBNAME' region -- --prompt="Select region > "`
\set region_id `echo :'region_row' | cut -sf1`

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

