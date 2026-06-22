#!/usr/bin/env bash
#
# Reorder the siblings of a parent by editing a plain-text list.
#
# Usage: scripts/reorder.sh <db> [type]
#   <db>    psql connection string / dbname (as accepted by psql)
#   [type]  one of: crag sector formation climb (prompted via fzf if omitted)
#
# Walks you through choosing what to reorder and within which parent, drops
# the current ordering into $EDITOR, and on confirmation rewrites the ranks
# for that parent in a single transaction: every sibling's rank is cleared,
# then the ones you left in the list are reassigned by their order.

set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

db="${1:-}"
if [ -z "$db" ]; then
  echo "usage: reorder.sh <db> [type]" >&2
  exit 1
fi
shift

type="${1:-}"
valid_types=(crag sector formation climb)

if [ -z "$type" ]; then
  type="$(printf '%s\n' "${valid_types[@]}" | fzf --prompt='Reorder which? > ')" || exit 1
fi

case "$type" in
  crag)      table=crags;      parents=(region) ;;
  sector)    table=sectors;    parents=(crag) ;;
  formation) table=formations; parents=(region crag sector) ;;
  climb)     table=climbs;     parents=(region crag sector formation) ;;
  *) echo "cannot reorder type: $type" >&2; exit 1 ;;
esac

# Choose the parent that scopes the ordering.
parent_row="$("$here/select.sh" "$db" "${parents[@]}" -- --prompt="Within which parent? > ")" || exit 1
parent_id="$(printf '%s' "$parent_row" | cut -f1)"
parent_type="$(printf '%s' "$parent_row" | cut -f2)"
if [ -z "$parent_id" ] || [ -z "$parent_type" ]; then
  echo "no parent selected" >&2
  exit 1
fi
parent_col="${parent_type}_id"

label_expr="coalesce(nullif(name, ''), nullif(slug, ''), '(unnamed)')"

# Field separator for reading psql rows. Tab cannot be used here: it is an IFS
# whitespace character, so bash collapses the run of separators around an empty
# field, and a NULL rank would shift the label into the rank variable. The unit
# separator is not IFS whitespace, so empty fields survive intact.
sep=$'\x1f'

# Fetch the siblings, ordered ones first.
rows="$(psql -X -F "$sep" "$db" -At <<SQL
SELECT id, rank, $label_expr
FROM climb.$table
WHERE $parent_col = '$parent_id'::uuid
ORDER BY rank NULLS LAST, $label_expr;
SQL
)"

if [ -z "$rows" ]; then
  echo "no ${type}s under ${parent_type} ${parent_id}" >&2
  exit 0
fi

# Build the editable template.
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
"$here/order-from-rank.sh" "$type" "$parent_type" "$parent_id" <<<"$rows" >"$tmp"

"${EDITOR:-vi}" "$tmp"

# The full set of valid ids, used to reject typos.
ids=()
while IFS="$sep" read -r id rank label; do
  [ -n "$id" ] && ids+=("$id")
done <<<"$rows"

plan="$("$here/rank-from-order.sh" "${ids[@]}" <"$tmp")" || { echo "aborted" >&2; exit 1; }

# Assemble the VALUES list for the rank reassignment.
values=""
while IFS=$'\t' read -r rank id; do
  [ -z "$id" ] && continue
  v="('$id'::uuid, $rank)"
  values="${values:+$values, }$v"
done <<<"$plan"

# Apply in one transaction with a preview and a commit prompt.
gen="$(mktemp)"
trap 'rm -f "$tmp" "$gen"' EXIT
{
  echo "BEGIN;"
  echo "UPDATE climb.$table SET rank = NULL WHERE $parent_col = '$parent_id'::uuid;"
  if [ -n "$values" ]; then
    echo "UPDATE climb.$table AS c SET rank = v.rank"
    echo "FROM (VALUES $values) AS v(id, rank)"
    echo "WHERE c.id = v.id;"
  fi
  echo "SELECT id, rank, $label_expr AS name"
  echo "FROM climb.$table WHERE $parent_col = '$parent_id'::uuid"
  echo "ORDER BY rank NULLS LAST, $label_expr;"
  echo "\\prompt 'Commit? (y/N): ' confirm"
  echo "\\if :confirm"
  echo "  COMMIT;"
  echo "\\else"
  echo "  ROLLBACK;"
  echo "\\endif"
} >"$gen"

psql -X -f "$gen" "$db"
