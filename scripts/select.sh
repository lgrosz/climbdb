#!/usr/bin/env bash
set -euo pipefail

db="$1"
shift

types=()
fzf_args=()

parsing_types=1

for arg in "$@"; do
  if [ "$arg" = "--" ]; then
    parsing_types=0
    continue
  fi

  if [ $parsing_types -eq 1 ]; then
    types+=("$arg")
  else
    fzf_args+=("$arg")
  fi
done

if [ ${#types[@]} -eq 0 ]; then
  echo "no types provided" >&2
  exit 1
fi

query_parts=()

# Every type selects the same shape -- id, type, name, slug, display -- so that
# nothing downstream branches per type and mixed-type lists can be unioned.
for t in "${types[@]}"; do
  case "$t" in
    region)
      query_parts+=("select id, 'region', name, slug, concat_ws(' ', name, slug, 'region', id) as display from climb.regions")
      ;;
    crag)
      query_parts+=("select id, 'crag', name, slug, concat_ws(' ', name, slug, 'crag', id) as display from climb.crags")
      ;;
    sector)
      query_parts+=("select id, 'sector', name, slug, concat_ws(' ', name, slug, 'sector', id) as display from climb.sectors")
      ;;
    formation)
      query_parts+=("select id, 'formation', name, slug, concat_ws(' ', name, slug, 'formation', id) as display from climb.formations")
      ;;
    climb)
      query_parts+=("select id, 'climb', name, slug, concat_ws(' ', name, slug, 'climb', id) as display from climb.climbs")
      ;;
    climber)
      query_parts+=("select id, 'climber', concat_ws(' ', first_name, last_name) as name, slug, concat_ws(' ', first_name, last_name, slug, 'climber', id) as display from climb.climbers")
      ;;
    *)
      echo "unknown type: $t" >&2
      exit 1
      ;;
  esac
done

sql=""

for part in "${query_parts[@]}"; do
  if [ -z "$sql" ]; then
    sql="$part"
  else
    sql="$sql
union all
$part"
  fi
done

# The display string is pre-joined in SQL because fzf only reinserts the
# delimiter within a contiguous --with-nth range, so reassembling fields there
# runs them together. --print-query puts the typed query on the first line,
# ahead of any selected rows, so we can fall back to it when nothing matched.
result="$(
  psql -X -F $'\t' "$db" -At <<SQL | fzf --delimiter=$'\t' --with-nth=-1 --print-query "${fzf_args:+"${fzf_args[@]}"}"
$sql
order by 2, 3;
SQL
)" || true

query="$(head -n1 <<<"$result")"
rows="$(tail -n +2 <<<"$result")"

if [ -n "$rows" ]; then
  # Confirm each pick on stderr so it stays visible after fzf closes; stdout is
  # reserved for the raw rows the callers parse.
  awk -F'\t' '
    {
      name = $3
      slug = $4
      desc = name
      if (slug != "") desc = (desc != "" ? desc " [" slug "]" : "[" slug "]")
      desc = (desc != "" ? desc " (" $1 ")" : "(" $1 ")")
      print "Selected " $2 ": " desc
    }
  ' <<<"$rows" >&2

  printf '%s\n' "$rows"
else
  printf '%s\n' "$query"
fi
