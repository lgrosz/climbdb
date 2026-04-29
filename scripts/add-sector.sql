\echo 'Add a new sector'

\prompt 'Name: ' name
\prompt 'Slug: ' slug

\set crag_row `scripts/select.sh :'DBNAME' crag -- --prompt="Select crag > "`
\set crag_id `echo :'crag_row' | cut -f1`

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

