#!/usr/bin/env bats

setup() {
  DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)"
  GEOM="$DIR/geom.sh"
}

# ---------------------------------------------------------------------------
# WKT pass-through
# ---------------------------------------------------------------------------

@test "WKT: POINT" {
  run "$GEOM" 'POINT(-103.46 43.88)'
  [ "$status" -eq 0 ]
  [ "$output" = 'POINT(-103.46 43.88)' ]
}

@test "WKT: LINESTRING" {
  run "$GEOM" 'LINESTRING(0 0, 1 1)'
  [ "$status" -eq 0 ]
  [ "$output" = 'LINESTRING(0 0, 1 1)' ]
}

@test "WKT: POLYGON" {
  run "$GEOM" 'POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))'
  [ "$status" -eq 0 ]
  [ "$output" = 'POLYGON((0 0, 1 0, 1 1, 0 1, 0 0))' ]
}

@test "WKT: case-insensitive" {
  run "$GEOM" 'point(-103.46 43.88)'
  [ "$status" -eq 0 ]
  [ "$output" = 'point(-103.46 43.88)' ]
}

# ---------------------------------------------------------------------------
# Decimal degrees: bare lat, lon
# ---------------------------------------------------------------------------

@test "decimal degrees: positive lat, negative lon" {
  run "$GEOM" '43.889046, -103.460229'
  [ "$status" -eq 0 ]
  [ "$output" = 'POINT(-103.460229 43.889046)' ]
}

@test "decimal degrees: no comma" {
  run "$GEOM" '43.889046 -103.460229'
  [ "$status" -eq 0 ]
  [ "$output" = 'POINT(-103.460229 43.889046)' ]
}

# ---------------------------------------------------------------------------
# Decimal degrees: cardinal directions
# ---------------------------------------------------------------------------

@test "decimal degrees: N/W cardinals with degree symbol" {
  run "$GEOM" '43.889046°N 103.460229°W'
  [ "$status" -eq 0 ]
  [ "$output" = 'POINT(-103.460229 43.889046)' ]
}

@test "decimal degrees: N/W cardinals with comma" {
  run "$GEOM" '43.889046 N, 103.460229 W'
  [ "$status" -eq 0 ]
  [ "$output" = 'POINT(-103.460229 43.889046)' ]
}

@test "decimal degrees: S/E cardinals negate lat" {
  run "$GEOM" '33.8688°S 151.2093°E'
  [ "$status" -eq 0 ]
  [ "$output" = 'POINT(151.2093 -33.8688)' ]
}

# ---------------------------------------------------------------------------
# Failure cases
# ---------------------------------------------------------------------------

@test "empty input exits 1" {
  run "$GEOM" ''
  [ "$status" -eq 1 ]
}

@test "plain text exits 1" {
  run "$GEOM" 'not a geometry'
  [ "$status" -eq 1 ]
}

