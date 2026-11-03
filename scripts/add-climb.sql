\echo 'Add a new climb'

\prompt 'Name: ' name
\set default_slug `scripts/slug.sh :'name'`
\set slug_prompt 'Slug [' :default_slug ']: '
\prompt :slug_prompt slug
select coalesce(nullif(:'slug', ''), :'default_slug') as slug
\gset
\prompt 'Grade: ' grade

\set area_row `scripts/select.sh :'DBNAME' area -- --prompt="Select area > "`
\set area_id `echo :'area_row' | cut -sf1`

BEGIN;

INSERT INTO climb.climbs (
  name,
  slug,
  grade,
  area_id
) VALUES (
  nullif(:'name', ''),
  nullif(:'slug', ''),
  nullif(:'grade', ''),
  nullif(:'area_id', '')::uuid
) RETURNING *;

\prompt 'Commit? (y/N): ' confirm

\if :confirm
  COMMIT;
\else
  ROLLBACK;
\endif

