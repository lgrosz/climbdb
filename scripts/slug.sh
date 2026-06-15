#!/usr/bin/env bash
#
# Derive a URL-safe slug from a name.
#
# Source it to use the `slugify` function, or run it directly:
#   scripts/slug.sh "El Capitan — The Nose"  ->  el-capitan-the-nose

slugify() {
  printf '%s' "$*" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E "s/'//g; s/[^a-z0-9]+/-/g; s/^-+//; s/-+$//"
}

# Run as a script (rather than sourced): slugify the arguments.
if [ "${0##*/}" = "slug.sh" ]; then
  slugify "$@"
fi
