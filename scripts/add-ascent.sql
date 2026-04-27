\echo 'Add a new ascent'

\prompt 'Climb: ' climb

-- Try direct lookup
SELECT (
  SELECT id::text
  FROM climb.climbs
  WHERE id::text = :'climb'
     OR slug = :'climb'
  LIMIT 1
) AS climb_id
\gset

-- Search for climb
\if :{?climb_id}
\else
  \set climb_row `scripts/select.sh :'DBNAME' climb`
  \set climb_id `echo :'climb_row' | cut -f1`
\endif

\prompt 'Ascent window (e.g. [2024-01-01,2024-01-02] or leave blank): ' ascent_window
\prompt 'Notes: ' notes
\prompt 'Style (comma-separated): ' style
\prompt 'Significance (comma-separated): ' significance

\echo 'Select ascent members (TAB to multi-select, ENTER to confirm)'

\set climber_ids `scripts/select.sh :'DBNAME' climber -- -m | awk -F'\t' '{print $1}' | tr '\n' ','  | sed 's/,$//'`

BEGIN;

SELECT uuidv7()::text AS ascent_id \gset

INSERT INTO climb.ascents (
  id,
  climb_id,
  ascent_window,
  notes,
  style,
  significance
) VALUES (
  :'ascent_id'::uuid,
  nullif(:'climb_id','')::uuid,
  nullif(:'ascent_window','')::daterange,
  nullif(:'notes',''),
  CASE
    WHEN nullif(:'style','') IS NULL THEN '{}'::text[]
    ELSE string_to_array(replace(:'style',' ',''), ',')
  END,
  CASE
    WHEN nullif(:'significance','') IS NULL THEN '{}'::text[]
    ELSE string_to_array(replace(:'significance',' ',''), ',')
  END
) RETURNING *;

INSERT INTO climb.ascent_members (ascent_id, climber_id)
SELECT :'ascent_id'::uuid, unnest(string_to_array(:'climber_ids', ','))::uuid
RETURNING *;

\prompt 'Commit? (y/N): ' confirm

\if :confirm
  COMMIT;
\else
  ROLLBACK;
\endif
