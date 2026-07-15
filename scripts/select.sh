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

for t in "${types[@]}"; do
  case "$t" in
    region)
      query_parts+=("select id, 'region', name, slug from climb.regions")
      ;;
    crag)
      query_parts+=("select id, 'crag', name, slug from climb.crags")
      ;;
    sector)
      query_parts+=("select id, 'sector', name, slug from climb.sectors")
      ;;
    formation)
      query_parts+=("select id, 'formation', name, slug from climb.formations")
      ;;
    climb)
      query_parts+=("select id, 'climb', name, slug from climb.climbs")
      ;;
    climber)
      query_parts+=("select id, 'climber', last_name, first_name, slug from climb.climbers")
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

# --print-query puts the typed query on the first line, ahead of any selected
# rows, so we can fall back to it when nothing matched.
result="$(
  psql -X -F $'\t' "$db" -At <<SQL | fzf --delimiter=$'\t' --with-nth=3..,2,1 --print-query "${fzf_args:+"${fzf_args[@]}"}"
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
      type = $2
      if (type == "climber") {
        name = $4
        if ($3 != "") name = (name != "" ? name " " $3 : $3)
        slug = $5
      } else {
        name = $3
        slug = $4
      }
      desc = name
      if (slug != "") desc = (desc != "" ? desc " [" slug "]" : "[" slug "]")
      desc = (desc != "" ? desc " (" $1 ")" : "(" $1 ")")
      print "Selected " type ": " desc
    }
  ' <<<"$rows" >&2

  printf '%s\n' "$rows"
else
  printf '%s\n' "$query"
fi
