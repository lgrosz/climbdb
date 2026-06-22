#!/usr/bin/env bats

setup() {
  DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)"
  ORDER="$DIR/order-from-rank.sh"
  RANK="$DIR/rank-from-order.sh"

  A='00000000-0000-0000-0000-00000000000a'
  B='00000000-0000-0000-0000-00000000000b'
  C='00000000-0000-0000-0000-00000000000c'
  D='00000000-0000-0000-0000-00000000000d'
  PARENT='00000000-0000-0000-0000-0000000000f0'
}

# One input row: id, rank, label. An empty rank means unordered.
row() {
  printf '%s\x1f%s\x1f%s\n' "$1" "$2" "$3"
}

# The body of a template section, with blanks and the section markers removed.
section() {
  awk -v want="$1" '
    /^# --- / { in_section = ($0 ~ want); next }
    in_section && NF && $0 != "#" { print }
  ' <<<"$output"
}

# ---------------------------------------------------------------------------
# Labels
# ---------------------------------------------------------------------------

@test "a ranked row keeps its label" {
  run "$ORDER" climb formation "$PARENT" <<<"$(row "$A" 1 Borderline)"
  [ "$status" -eq 0 ]
  [ "$(section Ordered)" = "$(printf '%s\tBorderline' "$A")" ]
}

@test "an unranked row keeps its label" {
  run "$ORDER" climb formation "$PARENT" <<<"$(row "$A" '' Borderline)"
  [ "$status" -eq 0 ]
  [ "$(section Unordered)" = "$(printf '# %s\tBorderline' "$A")" ]
}

@test "a label with spaces survives intact" {
  run "$ORDER" climb formation "$PARENT" <<<"$(row "$A" 1 'Cross Border Xpress')"
  [ "$status" -eq 0 ]
  [ "$(section Ordered)" = "$(printf '%s\tCross Border Xpress' "$A")" ]
}

# ---------------------------------------------------------------------------
# Ordered and unordered rows are kept apart
# ---------------------------------------------------------------------------

@test "ranked rows are listed in the order given" {
  run "$ORDER" climb formation "$PARENT" <<EOF
$(row "$A" 1 First)
$(row "$B" 2 Second)
$(row "$C" 3 Third)
EOF
  [ "$status" -eq 0 ]
  [ "$(section Ordered)" = "$(printf '%s\tFirst\n%s\tSecond\n%s\tThird' "$A" "$B" "$C")" ]
  [ -z "$(section Unordered)" ]
}

@test "unranked rows are commented out under Unordered" {
  run "$ORDER" climb formation "$PARENT" <<EOF
$(row "$A" 1 Ranked)
$(row "$B" '' Unranked)
EOF
  [ "$status" -eq 0 ]
  [ "$(section Ordered)" = "$(printf '%s\tRanked' "$A")" ]
  [ "$(section Unordered)" = "$(printf '# %s\tUnranked' "$B")" ]
}

@test "with nothing ranked the Ordered section is empty" {
  run "$ORDER" climb formation "$PARENT" <<EOF
$(row "$A" '' One)
$(row "$B" '' Two)
EOF
  [ "$status" -eq 0 ]
  [ -z "$(section Ordered)" ]
  [ "$(section Unordered)" = "$(printf '# %s\tOne\n# %s\tTwo' "$A" "$B")" ]
}

# ---------------------------------------------------------------------------
# Ties
# ---------------------------------------------------------------------------

@test "rows sharing a rank share a line" {
  run "$ORDER" climb formation "$PARENT" <<EOF
$(row "$A" 1 First)
$(row "$B" 2 Tied)
$(row "$C" 2 AlsoTied)
$(row "$D" 3 Last)
EOF
  [ "$status" -eq 0 ]
  [ "$(section Ordered)" = "$(printf '%s\tFirst\n%s\tTied\t%s\tAlsoTied\n%s\tLast' "$A" "$B" "$C" "$D")" ]
}

@test "a tie in the last position is still emitted" {
  run "$ORDER" climb formation "$PARENT" <<EOF
$(row "$A" 1 First)
$(row "$B" 2 Tied)
$(row "$C" 2 AlsoTied)
EOF
  [ "$status" -eq 0 ]
  [ "$(section Ordered)" = "$(printf '%s\tFirst\n%s\tTied\t%s\tAlsoTied' "$A" "$B" "$C")" ]
}

@test "equal ranks that are not adjacent are not tied together" {
  run "$ORDER" climb formation "$PARENT" <<EOF
$(row "$A" 1 First)
$(row "$B" 2 Second)
$(row "$C" 1 Later)
EOF
  [ "$status" -eq 0 ]
  [ "$(section Ordered)" = "$(printf '%s\tFirst\n%s\tSecond\n%s\tLater' "$A" "$B" "$C")" ]
}

# ---------------------------------------------------------------------------
# Header
# ---------------------------------------------------------------------------

@test "the header names what is being reordered" {
  run "$ORDER" climb formation "$PARENT" <<<"$(row "$A" 1 First)"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "# Reordering climbs within formation $PARENT" ]
}

@test "a missing argument is an error" {
  run "$ORDER" climb formation <<<"$(row "$A" 1 First)"
  [ "$status" -ne 0 ]
}

# ---------------------------------------------------------------------------
# Round trip through rank-from-order.sh
# ---------------------------------------------------------------------------

@test "an unedited template reproduces the ranks it was built from" {
  template="$("$ORDER" climb formation "$PARENT" <<EOF
$(row "$A" 1 First)
$(row "$B" 2 Second)
$(row "$C" 3 Third)
EOF
)"
  run "$RANK" "$A" "$B" "$C" <<<"$template"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "$(printf '1\t%s' "$A")" ]
  [ "${lines[1]}" = "$(printf '2\t%s' "$B")" ]
  [ "${lines[2]}" = "$(printf '3\t%s' "$C")" ]
}

@test "an unedited template preserves a tie" {
  template="$("$ORDER" climb formation "$PARENT" <<EOF
$(row "$A" 1 First)
$(row "$B" 2 Tied)
$(row "$C" 2 AlsoTied)
EOF
)"
  run "$RANK" "$A" "$B" "$C" <<<"$template"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "$(printf '1\t%s' "$A")" ]
  [ "${lines[1]}" = "$(printf '2\t%s' "$B")" ]
  [ "${lines[2]}" = "$(printf '2\t%s' "$C")" ]
}

@test "an unedited template leaves unranked rows unranked" {
  template="$("$ORDER" climb formation "$PARENT" <<EOF
$(row "$A" 1 Ranked)
$(row "$B" '' Unranked)
EOF
)"
  run "$RANK" "$A" "$B" <<<"$template"
  [ "$status" -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = "$(printf '1\t%s' "$A")" ]
}

@test "an unedited template densifies ranks that have gaps" {
  template="$("$ORDER" climb formation "$PARENT" <<EOF
$(row "$A" 1 First)
$(row "$B" 5 Second)
$(row "$C" 9 Third)
EOF
)"
  run "$RANK" "$A" "$B" "$C" <<<"$template"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "$(printf '1\t%s' "$A")" ]
  [ "${lines[1]}" = "$(printf '2\t%s' "$B")" ]
  [ "${lines[2]}" = "$(printf '3\t%s' "$C")" ]
}
