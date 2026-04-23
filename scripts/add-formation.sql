\echo 'Add a new formation'

\prompt 'Name: ' name
\prompt 'Slug: ' slug
\prompt 'Geometry: ' geom
\prompt 'Parent (press enter)...' _

-- Search for parent
\set parent_row `scripts/select.sh :'DBNAME' region crag sector`
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

\echo 'Preview:'
select
  :'name' as name,
  nullif(:'slug', '') as slug,
  nullif(:'geom', '') as geom,
  nullif(:'parent_type', '') as parent_type,
  nullif(:'parent_id', '')::uuid as :parent_col;

\prompt 'Insert? (y/N): ' confirm

\if :confirm
  insert into climb.formations (
    name,
    slug,
    geom,
    :parent_col
  ) values (
    nullif(:'name', ''),
    nullif(:'slug', ''),
    nullif(:'geom', ''),
    nullif(:'parent_id', '')::uuid
  );
\else
  \echo 'Canceled'
\endif

