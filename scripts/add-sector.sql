\echo 'Add a new sector'

\prompt 'Name: ' name
\prompt 'Slug: ' slug
\prompt 'Crag: ' crag

-- Try direct lookup
SELECT (
  SELECT id::text
  FROM climb.crags
  WHERE id::text = :'crag'
     OR slug = :'crag'
  LIMIT 1
) AS crag_id
\gset

-- Search for crag
\if :{?crag_id}
\else
  \set crag_row `scripts/select.sh :'DBNAME' crag`
  \set crag_id `echo :'crag_row' | cut -f1`
\endif

-- TODO Abort if crag id does not exist, because we it _will_ fail based on constraints

\echo 'Preview:'
select
  :'name' as name,
  nullif(:'slug','') as slug,
  nullif(:'crag_id','')::uuid as crag_id;

\prompt 'Insert? (y/N): ' confirm

\if :confirm
  insert into climb.sectors (
    name,
    slug,
    crag_id
  ) values (
    nullif(:'name', ''),
    nullif(:'slug', ''),
    nullif(:'crag_id', '')::uuid
  );
\else
  \echo 'Canceled'
\endif

