\echo 'Add a new ascent'

\set climb_row `scripts/select.sh :'DBNAME' climb -- --prompt="Select climb > "`
\set climb_id `echo :'climb_row' | cut -sf1`

\prompt 'Ascent window (e.g. 2024, 2024-04, 2024-04-01, [2024-04-01,2024-06-15)): ' raw_ascent_window

SELECT :'raw_ascent_window' != '' as ascent_window_provided
\gset

\if :ascent_window_provided
  -- Parse provided daterange
  \set ascent_window `scripts/daterange.sh :'raw_ascent_window'`

  SELECT :SHELL_EXIT_CODE != 0 as ascent_window_invalid
  \gset

  \if :ascent_window_invalid
    \echo 'Invalid ascent window'
    \quit
  \endif
\else
  \set ascent_window ''
\endif

\prompt 'Description: ' description
\prompt 'First ascent? (y/N): ' raw_first_ascent

\if :raw_first_ascent
  \set first_ascent 'true'
\else
  \set first_ascent 'false'
\endif

\echo 'Select ascent members (TAB to multi-select, ENTER to confirm)'

\set climber_ids `scripts/select.sh :'DBNAME' climber -- -m --prompt="Select ascent members > " | cut -sf1 | tr '\n' ','  | sed 's/,$//'`

BEGIN;

SELECT uuidv7()::text AS ascent_id \gset

INSERT INTO climb.ascents (
  id,
  climb_id,
  ascent_window,
  description,
  first_ascent
) VALUES (
  :'ascent_id'::uuid,
  nullif(:'climb_id','')::uuid,
  nullif(:'ascent_window','')::daterange,
  nullif(:'description',''),
  :'first_ascent'::boolean
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
