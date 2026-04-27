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
  \set region_row `scripts/select.sh :'DBNAME' region`
  \set region_id `echo :'region_row' | cut -f1`
\endif

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

