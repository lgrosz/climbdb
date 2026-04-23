#!/usr/bin/env bash

input="$*"

trimmed=$(echo "$input" | tr -d '\n' | sed 's/^ *//;s/ *$//')

# 1. WKT first
if echo "$trimmed" | grep -Eiq '^(point|linestring|polygon|multipoint|multilinestring|multipolygon)[[:space:]]*\('; then
  echo "$trimmed"
  exit 0
fi

# 2. Varying decimal degrees formats
# Examples:
#   43.889046°N 103.460229°W
#   43.889046 N, 103.460229 W
#   43.889046, -103.460229
if echo "$trimmed" | grep -Eq '[0-9]'; then
  lat=$(echo "$trimmed" | awk -F'[ ,]+' '{print $1}')
  lon=$(echo "$trimmed" | awk -F'[ ,]+' '{print $2}')

  normalize() {
    val="$1"

    num=$(echo "$val" | sed -E 's/[^0-9.+-]//g')

    if echo "$val" | grep -qi '[SW]'; then
      num="-$num"
    fi

    echo "$num"
  }

  lat_num=$(normalize "$lat")
  lon_num=$(normalize "$lon")

  if [ -n "$lat_num" ] && [ -n "$lon_num" ]; then
    echo "POINT($lon_num $lat_num)"
    exit 0
  fi
fi

exit 1
