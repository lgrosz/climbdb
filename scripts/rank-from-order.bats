#!/usr/bin/env bats

setup() {
  DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)"
  RANK="$DIR/rank-from-order.sh"

  A='00000000-0000-0000-0000-00000000000a'
  B='00000000-0000-0000-0000-00000000000b'
  C='00000000-0000-0000-0000-00000000000c'
}

# ---------------------------------------------------------------------------
# Basic ranking
# ---------------------------------------------------------------------------

@test "one id per line ranks in order" {
  run "$RANK" <<EOF
$A
$B
$C
EOF
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "$(printf '1\t%s' "$A")" ]
  [ "${lines[1]}" = "$(printf '2\t%s' "$B")" ]
  [ "${lines[2]}" = "$(printf '3\t%s' "$C")" ]
}

@test "labels after the id are ignored" {
  run "$RANK" <<EOF
$A	The Nose
$B	Salathe
EOF
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "$(printf '1\t%s' "$A")" ]
  [ "${lines[1]}" = "$(printf '2\t%s' "$B")" ]
}

# ---------------------------------------------------------------------------
# Ties
# ---------------------------------------------------------------------------

@test "multiple ids on one line share a rank, next line increments" {
  run "$RANK" <<EOF
$A	$B
$C
EOF
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "$(printf '1\t%s' "$A")" ]
  [ "${lines[1]}" = "$(printf '1\t%s' "$B")" ]
  [ "${lines[2]}" = "$(printf '2\t%s' "$C")" ]
}

# ---------------------------------------------------------------------------
# Ignored lines
# ---------------------------------------------------------------------------

@test "comment and blank lines do not consume a rank" {
  run "$RANK" <<EOF
# header

$A
  # indented comment
$B
EOF
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "$(printf '1\t%s' "$A")" ]
  [ "${lines[1]}" = "$(printf '2\t%s' "$B")" ]
}

@test "everything ignored yields no output" {
  run "$RANK" <<EOF
# only comments
EOF
  [ "$status" -eq 0 ]
  [ "$output" = "" ]
}

# ---------------------------------------------------------------------------
# Validation
# ---------------------------------------------------------------------------

@test "duplicate id is rejected" {
  run "$RANK" <<EOF
$A
$A
EOF
  [ "$status" -eq 1 ]
  [[ "$output" == *"duplicate id"* ]]
}

@test "id outside the valid set is rejected" {
  run "$RANK" "$A" "$B" <<EOF
$A
$C
EOF
  [ "$status" -eq 1 ]
  [[ "$output" == *"unknown id"* ]]
}

@test "ids within the valid set are accepted" {
  run "$RANK" "$A" "$B" "$C" <<EOF
$A
$B
EOF
  [ "$status" -eq 0 ]
  [ "${lines[0]}" = "$(printf '1\t%s' "$A")" ]
  [ "${lines[1]}" = "$(printf '2\t%s' "$B")" ]
}
