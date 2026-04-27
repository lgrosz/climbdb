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

BEGIN;

INSERT INTO climb.sectors (
  name,
  slug,
  crag_id
) VALUES (
  nullif(:'name', ''),
  nullif(:'slug', ''),
  nullif(:'crag_id', '')::uuid
) RETURNING *;

\prompt 'Commit? (y/N): ' confirm

\if :confirm
  COMMIT;
\else
  ROLLBACK;
\endif

