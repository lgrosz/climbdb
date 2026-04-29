#!/usr/bin/env bats

setup() {
  DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)"
  DATERANGE="$DIR/daterange.sh"
}

# ---------------------------------------------------------------------------
# Pass-through
# ---------------------------------------------------------------------------

@test "pass-through: closed range" {
  run "$DATERANGE" '[2024-04-01,2024-06-15]'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-04-01,2024-06-15]' ]
}

@test "pass-through: half-open range" {
  run "$DATERANGE" '[2024-04-01,2024-06-15)'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-04-01,2024-06-15)' ]
}

# ---------------------------------------------------------------------------
# Single point — year
# ---------------------------------------------------------------------------

@test "year only" {
  run "$DATERANGE" '2024'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-01-01,2025-01-01)' ]
}

# ---------------------------------------------------------------------------
# Single point — month
# ---------------------------------------------------------------------------

@test "year-month" {
  run "$DATERANGE" '2024-04'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-04-01,2024-05-01)' ]
}

@test "year-month: december wraps to next year" {
  run "$DATERANGE" '2024-12'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-12-01,2025-01-01)' ]
}

@test "named month: April 2024" {
  run "$DATERANGE" 'April 2024'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-04-01,2024-05-01)' ]
}

@test "named month abbreviated: Apr 2024" {
  run "$DATERANGE" 'Apr 2024'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-04-01,2024-05-01)' ]
}

@test "named month case-insensitive: APRIL 2024" {
  run "$DATERANGE" 'APRIL 2024'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-04-01,2024-05-01)' ]
}

# ---------------------------------------------------------------------------
# Single point — day
# ---------------------------------------------------------------------------

@test "full date" {
  run "$DATERANGE" '2024-04-01'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-04-01,2024-04-01]' ]
}

@test "named month with day: April 1, 2024" {
  run "$DATERANGE" 'April 1, 2024'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-04-01,2024-04-01]' ]
}

@test "named month with day no comma: Apr 1 2024" {
  run "$DATERANGE" 'Apr 1 2024'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-04-01,2024-04-01]' ]
}

@test "day-first format: 1 April 2024" {
  run "$DATERANGE" '1 April 2024'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-04-01,2024-04-01]' ]
}

# ---------------------------------------------------------------------------
# Ranges — slash separator
# ---------------------------------------------------------------------------

@test "range: year/year" {
  run "$DATERANGE" '2024/2025'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-01-01,2026-01-01)' ]
}

@test "range: month/month" {
  run "$DATERANGE" '2024-04/2024-06'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-04-01,2024-07-01)' ]
}

@test "range: date/date" {
  run "$DATERANGE" '2024-04-01/2024-06-15'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-04-01,2024-06-16)' ]
}

@test "range: month/month spanning year boundary" {
  run "$DATERANGE" '2024-11/2025-01'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-11-01,2025-02-01)' ]
}

# ---------------------------------------------------------------------------
# Ranges — "to" separator
# ---------------------------------------------------------------------------

@test "range: year to year" {
  run "$DATERANGE" '2024 to 2025'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-01-01,2026-01-01)' ]
}

@test "range: date to date" {
  run "$DATERANGE" '2024-04-01 to 2024-06-15'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-04-01,2024-06-16)' ]
}

@test "range: TO case-insensitive" {
  run "$DATERANGE" '2024 TO 2025'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-01-01,2026-01-01)' ]
}

# ---------------------------------------------------------------------------
# Ranges — spaced hyphen separator
# ---------------------------------------------------------------------------

@test "range: date - date" {
  run "$DATERANGE" '2024-04-01 - 2024-06-15'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-04-01,2024-06-16)' ]
}

@test "range: year - year" {
  run "$DATERANGE" '2024 - 2025'
  [ "$status" -eq 0 ]
  [ "$output" = '[2024-01-01,2026-01-01)' ]
}

# ---------------------------------------------------------------------------
# Failure cases
# ---------------------------------------------------------------------------

@test "invalid input exits 1" {
  run "$DATERANGE" 'not a date'
  [ "$status" -eq 1 ]
}

@test "empty input exits 1" {
  run "$DATERANGE" ''
  [ "$status" -eq 1 ]
}

@test "unknown month name exits 1" {
  run "$DATERANGE" 'Jularch 2024'
  [ "$status" -eq 1 ]
}

