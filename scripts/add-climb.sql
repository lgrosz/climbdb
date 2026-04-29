\echo 'Add a new climb'

\prompt 'Name: ' name
\prompt 'Slug: ' slug
\prompt 'Grade: ' grade

-- Search for parent
\set parent_row `scripts/select.sh :'DBNAME' region crag sector formation -- --prompt="Select parent > "`
\set parent_id `echo :'parent_row' | cut -f1`
\set parent_type `echo :'parent_row' | cut -f2`

\echo 'Parent type:' :parent_type
\echo 'Parent id:' :parent_id

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

