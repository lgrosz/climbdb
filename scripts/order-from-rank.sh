#!/usr/bin/env bash
#
# Turn ranked sibling rows into the ordering template reorder.sh puts in front
# of the user. The inverse of rank-from-order.sh.
#
# Rows arrive on stdin as "<id><US><rank><US><label>", ranked ones first, where
# US is the unit separator. A tab cannot be used to separate these fields: it
# is an IFS whitespace character, so bash collapses runs of it and a row with
# no rank would lose a field and shift its label into the rank.
#
# Ranked rows are listed under "Ordered" and unranked ones are commented out
# under "Unordered". Rows sharing a rank are emitted on one line, which is how
# the template spells a tie; writing them on separate lines would silently
# break the tie when the template is saved unedited.
#
#   order-from-rank.sh climb formation <parent-id> < rows

set -euo pipefail

type="${1:?usage: order-from-rank.sh <type> <parent-type> <parent-id>}"
parent_type="${2:?usage: order-from-rank.sh <type> <parent-type> <parent-id>}"
parent_id="${3:?usage: order-from-rank.sh <type> <parent-type> <parent-id>}"

sep=$'\x1f'
tab=$'\t'

rows="$(cat)"

cat <<HEADER
# Reordering ${type}s within ${parent_type} ${parent_id}
#
# Topmost line is rank 1. Reorder, add, or remove lines freely.
# Put multiple ids on one line to tie them at the same rank.
# Lines beginning with # are ignored; text after an id is just a label.
# Uncomment a row under 'Unordered' to give it a rank; leave it
# commented to keep it unordered (NULL).
#
# --- Ordered ---
HEADER

prev_rank=""
line=""
while IFS="$sep" read -r id rank label; do
  if [ -z "$id" ] || [ -z "$rank" ]; then
    continue
  fi

  if [ -n "$line" ] && [ "$rank" = "$prev_rank" ]; then
    line="${line}${tab}${id}${tab}${label}"
  else
    if [ -n "$line" ]; then
      printf '%s\n' "$line"
    fi
    line="${id}${tab}${label}"
  fi
  prev_rank="$rank"
done <<<"$rows"

if [ -n "$line" ]; then
  printf '%s\n' "$line"
fi

echo "#"
echo "# --- Unordered ---"
while IFS="$sep" read -r id rank label; do
  if [ -n "$id" ] && [ -z "$rank" ]; then
    printf '# %s%s%s\n' "$id" "$tab" "$label"
  fi
done <<<"$rows"
