\echo 'Add a new crag'

\prompt 'Name: ' name
\prompt 'Slug: ' slug
\prompt 'Region: ' region

-- Try direct lookup
SELECT (
  SELECT id::text
  FROM climb.regions
  WHERE id::text = :'region'
     OR slug = :'region'
  LIMIT 1
) AS region_id
\gset

-- Search for region
\if :{?region_id}
\else
  \set region_id `psql :'DBNAME' -Atc "select id||' '||name||' '||slug from climb.regions order by name" | fzf | awk '{print $1}'`
\endif

insert into climb.crags (
  name,
  slug,
  region_id
) values (
  nullif(:'name', ''),
  nullif(:'slug', ''),
  nullif(:'region_id', '')::uuid
);
