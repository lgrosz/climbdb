#!/usr/bin/env bash
set -euo pipefail

db="$1"
shift

types=("$@")

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

psql -X -F $'\t' "$db" -At <<SQL |
$sql
order by 2, 3;
SQL
fzf --delimiter=$'\t' --with-nth=2..

