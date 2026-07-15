\echo 'Add a new climb'

\prompt 'Name: ' name
\set default_slug `scripts/slug.sh :'name'`
\set slug_prompt 'Slug [' :default_slug ']: '
\prompt :slug_prompt slug
select coalesce(nullif(:'slug', ''), :'default_slug') as slug
\gset
\prompt 'Grade: ' grade

-- Search for parent
\set parent_row `scripts/select.sh :'DBNAME' region crag sector formation -- --prompt="Select parent > "`
\set parent_id `echo :'parent_row' | cut -f1`
\set parent_type `echo :'parent_row' | cut -f2`

select :'parent_type' != '' as parent_is_valid
\gset

\if :parent_is_valid
\else
  -- Doesn't matter what this is because the id is going to be null
  \set parent_type 'region'
\endif

\set parent_col :parent_type'_id'

BEGIN;

INSERT INTO climb.climbs (
  name,
  slug,
  grade,
  :parent_col
) VALUES (
  nullif(:'name', ''),
  nullif(:'slug', ''),
  nullif(:'grade', ''),
  nullif(:'parent_id', '')::uuid
) RETURNING *;

\prompt 'Commit? (y/N): ' confirm

\if :confirm
  COMMIT;
\else
  ROLLBACK;
\endif

