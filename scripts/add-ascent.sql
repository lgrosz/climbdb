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

\echo 'Preview:'
select
  :'climb_id'::uuid as climb_id,
  nullif(:'ascent_window','')::daterange as ascent_window,
  nullif(:'notes','') as notes,
  CASE
    WHEN nullif(:'style','') IS NULL THEN '{}'::text[]
    ELSE string_to_array(replace(:'style',' ',''), ',')
  END as style,
  CASE
    WHEN nullif(:'significance','') IS NULL THEN '{}'::text[]
    ELSE string_to_array(replace(:'significance',' ',''), ',')
  END as significance;

\prompt 'Insert? (y/N): ' confirm

\if :confirm
  -- Generate ascent id (UUIDv7)
  select uuidv7()::text as ascent_id \gset

  insert into climb.ascents (
    id,
    climb_id,
    ascent_window,
    notes,
    style,
    significance
  ) values (
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
  );

  INSERT INTO climb.ascent_members (ascent_id, climber_id)
  SELECT :'ascent_id'::uuid, unnest(string_to_array(:'climber_ids', ','))::uuid;
\else
  \echo 'Canceled'
\endif
