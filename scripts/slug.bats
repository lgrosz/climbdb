#!/usr/bin/env bats

setup() {
  DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)"
  SLUG="$DIR/slug.sh"
}

# ---------------------------------------------------------------------------
# Basics
# ---------------------------------------------------------------------------

@test "simple name" {
  run "$SLUG" 'El Capitan'
  [ "$status" -eq 0 ]
  [ "$output" = 'el-capitan' ]
}

@test "lowercases" {
  run "$SLUG" 'EL CAPITAN'
  [ "$status" -eq 0 ]
  [ "$output" = 'el-capitan' ]
}

@test "digits are preserved" {
  run "$SLUG" 'Route 66'
  [ "$status" -eq 0 ]
  [ "$output" = 'route-66' ]
}

@test "already a slug is unchanged" {
  run "$SLUG" 'el-capitan'
  [ "$status" -eq 0 ]
  [ "$output" = 'el-capitan' ]
}

# ---------------------------------------------------------------------------
# Apostrophes
# ---------------------------------------------------------------------------

@test "apostrophe is stripped, not hyphenated" {
  run "$SLUG" "Devil's Tower"
  [ "$status" -eq 0 ]
  [ "$output" = 'devils-tower' ]
}

# ---------------------------------------------------------------------------
# Separators and punctuation collapse to a single hyphen
# ---------------------------------------------------------------------------

@test "em dash and surrounding spaces collapse to one hyphen" {
  run "$SLUG" 'El Capitan — The Nose'
  [ "$status" -eq 0 ]
  [ "$output" = 'el-capitan-the-nose' ]
}

@test "runs of spaces and punctuation collapse" {
  run "$SLUG" 'The  Nose!!!'
  [ "$status" -eq 0 ]
  [ "$output" = 'the-nose' ]
}

# ---------------------------------------------------------------------------
# Trimming leading/trailing hyphens
# ---------------------------------------------------------------------------

@test "leading and trailing whitespace is trimmed" {
  run "$SLUG" '  The Nose  '
  [ "$status" -eq 0 ]
  [ "$output" = 'the-nose' ]
}

@test "leading and trailing separators are trimmed" {
  run "$SLUG" '—Nose—'
  [ "$status" -eq 0 ]
  [ "$output" = 'nose' ]
}

# ---------------------------------------------------------------------------
# Argument handling
# ---------------------------------------------------------------------------

@test "multiple arguments are joined with a space" {
  run "$SLUG" The Nose
  [ "$status" -eq 0 ]
  [ "$output" = 'the-nose' ]
}

@test "empty input yields empty output" {
  run "$SLUG" ''
  [ "$status" -eq 0 ]
  [ "$output" = '' ]
}
