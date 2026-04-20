\echo 'Add a new climb'

\prompt 'Name: ' name
\prompt 'Slug: ' slug
\prompt 'Parent (press enter)...' _

-- Search for parent
-- TODO I desperately need a way to split into lines for readability
\set parent `psql :'DBNAME' -Atc "select format('region %s %s %s', id, name, slug) from climb.regions union all select format('crag %s %s %s', id, name, slug) from climb.crags union all select format('sector %s %s %s', id, name, slug) from climb.sectors union all select format('formation %s %s %s', id, name, slug) from climb.formations order by 1 " | fzf`

\set parent_type `echo :'parent' | awk '{print $1}'`
\set parent_id `echo :'parent' | awk '{print $2}'`

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
  nullif(:'parent_id', '')::uuid as :parent_col;

\prompt 'Insert? (y/N): ' confirm

\if :confirm
  insert into climb.climbs (
    name,
    slug,
    :parent_col
  ) values (
    nullif(:'name', ''),
    nullif(:'slug', ''),
    nullif(:'parent_id', '')::uuid
  );
\else
  \echo 'Canceled'
\endif

