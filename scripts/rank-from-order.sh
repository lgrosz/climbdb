#!/usr/bin/env bash
#
# Turn an edited ordering template into "<rank>\t<id>" lines.
#
# Reads the template on stdin. Blank lines and lines whose first non-space
# character is '#' are ignored. Every UUID found on a remaining line is
# assigned that line's rank; any other tokens are treated as decorative
# labels and ignored. Ranks are dense and 1-based in line order, so placing
# multiple UUIDs on one line ties them at the same rank.
#
# UUIDs passed as arguments form the set of valid ids; a UUID outside that set
# is an error. A UUID appearing more than once is always an error. With no
# arguments, membership is not checked (useful for testing the ranking alone).
#
#   scripts/rank-from-order.sh id1 id2 id3 < edited.txt

set -euo pipefail

uuid_re='[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}'

# Space-padded membership sets (bash 3.2 has no associative arrays; UUIDs
# contain no spaces, so " $id " matching is safe).
have_valid=0
[ "$#" -gt 0 ] && have_valid=1
valid=" $* "
seen=" "
rank=0

while IFS= read -r line || [ -n "$line" ]; do
  # Skip blank lines and comments (leading whitespace allowed).
  trimmed="${line#"${line%%[![:space:]]*}"}"
  case "$trimmed" in
    '' | '#'*) continue ;;
  esac

  # Collect every UUID on the line, in order.
  ids=()
  rest="$line"
  while [[ "$rest" =~ ($uuid_re) ]]; do
    ids+=("${BASH_REMATCH[1]}")
    rest="${rest#*"${BASH_REMATCH[1]}"}"
  done
  [ "${#ids[@]}" -eq 0 ] && continue

  rank=$((rank + 1))
  for id in "${ids[@]}"; do
    case "$seen" in
      *" $id "*) echo "duplicate id: $id" >&2; exit 1 ;;
    esac
    if [ "$have_valid" -eq 1 ]; then
      case "$valid" in
        *" $id "*) : ;;
        *) echo "unknown id: $id" >&2; exit 1 ;;
      esac
    fi
    seen="$seen$id "
    printf '%d\t%s\n' "$rank" "$id"
  done
done
