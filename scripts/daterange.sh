#!/usr/bin/env bash
# daterange.sh — parse common date formats into a PostgreSQL daterange
#
# Output is always a discrete daterange in the form [start,end)
# normalized so the end bound is exclusive.
#
# Supported single-point formats (expanded to a range):
#   2024                    → [2024-01-01,2025-01-01)
#   2024-04                 → [2024-04-01,2024-05-01)
#   2024-04-01              → [2024-04-01,2024-04-02)
#   April 2024 / Apr 2024   → [2024-04-01,2024-05-01)
#   April 1 2024 / Apr 1, 2024 / 1 April 2024 / etc.
#
# Supported range formats:
#   2024/2025               → [2024-01-01,2025-01-01)   (year/year)
#   2024-04/2024-06         → [2024-04-01,2024-07-01)   (month/month)
#   2024-04-01/2024-06-15   → [2024-04-01,2024-06-16)   (date/date)
#   2024 to 2025            → same as above, "to" separator
#   2024-04-01 - 2024-06-15 → same, "-" separator (with spaces)
#
# Exits 0 and prints the range on success.
# Exits 1 and prints an error to stderr on failure.

set -euo pipefail

input="$*"
trimmed=$(printf '%s' "$input" | sed 's/^ *//;s/ *$//')

# Pass-through: already a PostgreSQL daterange literal e.g. [2024-04-01,2024-06-15)
if printf '%s' "$trimmed" | grep -Eq '^[[(][0-9]{4}-[0-9]{2}-[0-9]{2},[0-9]{4}-[0-9]{2}-[0-9]{2}[])]$'; then
  printf '%s\n' "$trimmed"
  exit 0
fi

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

month_to_num() {
  case "$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')" in
    jan|january)   printf '01' ;;
    feb|february)  printf '02' ;;
    mar|march)     printf '03' ;;
    apr|april)     printf '04' ;;
    may)           printf '05' ;;
    jun|june)      printf '06' ;;
    jul|july)      printf '07' ;;
    aug|august)    printf '08' ;;
    sep|september) printf '09' ;;
    oct|october)   printf '10' ;;
    nov|november)  printf '11' ;;
    dec|december)  printf '12' ;;
    *)             printf '' ;;
  esac
}

# Zero-pad a number to 2 digits
pad2() {
  printf '%02d' "$1"
}

# Advance a year by N
next_year() {
  printf '%d' $(( $1 + $2 ))
}

# Advance a month by N, returning "YYYY MM" (space separated)
next_month() {
  y=$1; m=$2; n=$3
  m=$(( 10#$m + n ))
  while [ $m -gt 12 ]; do
    m=$(( m - 12 ))
    y=$(( y + 1 ))
  done
  printf '%d %02d' "$y" "$m"
}

# Advance a date by N days using only POSIX tools.
# We only ever advance by 1 so a simple end-of-month check is enough.
next_day() {
  y=$1; m=$2; d=$3
  # Days in month
  case $m in
    01|03|05|07|08|10|12) dim=31 ;;
    04|06|09|11)           dim=30 ;;
    02)
      if [ $(( y % 4 )) -eq 0 ] && { [ $(( y % 100 )) -ne 0 ] || [ $(( y % 400 )) -eq 0 ]; }; then
        dim=29
      else
        dim=28
      fi
      ;;
  esac
  d=$(( 10#$d + 1 ))
  if [ $d -gt $dim ]; then
    d=1
    read ny nm <<EOF
$(next_month "$y" "$m" 1)
EOF
    y=$ny; m=$nm
  fi
  printf '%d %02d %02d' "$y" "$m" "$d"
}

# Parse a single token into canonical "YYYY", "YYYY MM", or "YYYY MM DD"
# Prints nothing and returns 1 on failure.
parse_point() {
  p="$1"

  # ---- purely numeric ----

  # YYYY
  if printf '%s' "$p" | grep -Eq '^[0-9]{4}$'; then
    printf '%s' "$p"
    return 0
  fi

  # YYYY-MM or YYYY/MM
  if printf '%s' "$p" | grep -Eq '^[0-9]{4}[-/][0-9]{1,2}$'; then
    y=$(printf '%s' "$p" | cut -c1-4)
    m=$(printf '%s' "$p" | sed 's/^[0-9][0-9][0-9][0-9][-\/]//')
    printf '%s %02d' "$y" "$m"
    return 0
  fi

  # YYYY-MM-DD or YYYY/MM/DD
  if printf '%s' "$p" | grep -Eq '^[0-9]{4}[-/][0-9]{1,2}[-/][0-9]{1,2}$'; then
    y=$(printf '%s' "$p" | cut -c1-4)
    rest=$(printf '%s' "$p" | cut -c6-)
    m=$(printf '%s' "$rest" | awk -F'[-/]' '{print $1}')
    d=$(printf '%s' "$rest" | awk -F'[-/]' '{print $2}')
    printf '%s %02d %02d' "$y" "$m" "$d"
    return 0
  fi

  # ---- month-name formats ----

  # "April 2024" or "Apr 2024"
  if printf '%s' "$p" | grep -Eiq '^[A-Za-z]+ +[0-9]{4}$'; then
    mon=$(printf '%s' "$p" | awk '{print $1}')
    y=$(printf '%s' "$p" | awk '{print $2}')
    mn=$(month_to_num "$mon")
    if [ -z "$mn" ]; then return 1; fi
    printf '%s %s' "$y" "$mn"
    return 0
  fi

  # "April 1, 2024" or "Apr 1 2024"
  if printf '%s' "$p" | grep -Eiq '^[A-Za-z]+ +[0-9]{1,2},? +[0-9]{4}$'; then
    mon=$(printf '%s' "$p" | awk '{print $1}')
    d=$(printf '%s' "$p"   | awk '{print $2}' | tr -d ',')
    y=$(printf '%s' "$p"   | awk '{print $3}')
    mn=$(month_to_num "$mon")
    if [ -z "$mn" ]; then return 1; fi
    printf '%s %s %02d' "$y" "$mn" "$d"
    return 0
  fi

  # "1 April 2024" or "1 Apr 2024"
  if printf '%s' "$p" | grep -Eiq '^[0-9]{1,2} +[A-Za-z]+ +[0-9]{4}$'; then
    d=$(printf '%s' "$p"   | awk '{print $1}')
    mon=$(printf '%s' "$p" | awk '{print $2}')
    y=$(printf '%s' "$p"   | awk '{print $3}')
    mn=$(month_to_num "$mon")
    if [ -z "$mn" ]; then return 1; fi
    printf '%s %s %02d' "$y" "$mn" "$d"
    return 0
  fi

  return 1
}

# Convert a parsed point ("YYYY", "YYYY MM", "YYYY MM DD") to a
# pair of ISO dates: start and exclusive-end.
point_to_range() {
  words=$(printf '%s' "$1" | wc -w | tr -d ' ')

  if [ "$words" -eq 1 ]; then
    y="$1"
    start=$(printf '%s-01-01' "$y")
    ny=$(next_year "$y" 1)
    end=$(printf '%s-01-01' "$ny")

  elif [ "$words" -eq 2 ]; then
    y=$(printf '%s' "$1" | awk '{print $1}')
    m=$(printf '%s' "$1" | awk '{print $2}')
    start=$(printf '%s-%s-01' "$y" "$m")
    read ny nm <<EOF
$(next_month "$y" "$m" 1)
EOF
    end=$(printf '%s-%s-01' "$ny" "$nm")

  elif [ "$words" -eq 3 ]; then
    y=$(printf '%s' "$1" | awk '{print $1}')
    m=$(printf '%s' "$1" | awk '{print $2}')
    d=$(printf '%s' "$1" | awk '{print $3}')
    start=$(printf '%s-%s-%s' "$y" "$m" "$d")
    # inclusive single-day: [date,date]
    end="$start"
    printf '[%s,%s]' "$start" "$end"
    return 0
  fi

  printf '[%s,%s)' "$start" "$end"
}

# ---------------------------------------------------------------------------
# Split input into (at most) two parts around a range separator.
# Separators tried: " to ", " - " (spaced hyphen), "/"
# A bare "/" is also used for YYYY/MM/DD so we only treat it as a separator
# when neither part looks like a full date with slashes already handled.
# ---------------------------------------------------------------------------

left=""
right=""

# "to" separator
if printf '%s' "$trimmed" | grep -Eiq ' +to +'; then
  left=$(printf '%s' "$trimmed"  | sed -E 's/ +[Tt][Oo] +.*//')
  right=$(printf '%s' "$trimmed" | sed -E 's/.* +[Tt][Oo] +//')

# spaced hyphen separator "2024-04-01 - 2024-06-15"
# (must have spaces around the hyphen to avoid matching date hyphens)
elif printf '%s' "$trimmed" | grep -Eq ' - '; then
  left=$(printf '%s' "$trimmed"  | sed 's/ - .*//')
  right=$(printf '%s' "$trimmed" | sed 's/.* - //')

# slash separator — only when neither side contains its own slashes
# (i.e. not a YYYY/MM/DD single date)
elif printf '%s' "$trimmed" | grep -Eq '^[^/]+/[^/]+$'; then
  left=$(printf '%s' "$trimmed"  | cut -d'/' -f1)
  right=$(printf '%s' "$trimmed" | cut -d'/' -f2)
fi

# ---------------------------------------------------------------------------
# If we have two parts, parse each independently then build the range.
# ---------------------------------------------------------------------------

if [ -n "$left" ] && [ -n "$right" ]; then
  lp=$(parse_point "$left")  || { printf 'could not parse start: %s\n' "$left" >&2; exit 1; }
  rp=$(parse_point "$right") || { printf 'could not parse end: %s\n' "$right"   >&2; exit 1; }

  # For the right side of an explicit range we want the *inclusive* end,
  # so we take the start of the right point's natural range (e.g. "2024"
  # as the end means up to and including all of 2024 → end = 2025-01-01).
  lwords=$(printf '%s' "$lp" | wc -w | tr -d ' ')
  rwords=$(printf '%s' "$rp" | wc -w | tr -d ' ')

  # start = first day of left point
  case $lwords in
    1) start=$(printf '%s-01-01' "$lp") ;;
    2) ly=$(printf '%s' "$lp" | awk '{print $1}'); lm=$(printf '%s' "$lp" | awk '{print $2}')
       start=$(printf '%s-%s-01' "$ly" "$lm") ;;
    3) ly=$(printf '%s' "$lp" | awk '{print $1}'); lm=$(printf '%s' "$lp" | awk '{print $2}'); ld=$(printf '%s' "$lp" | awk '{print $3}')
       start=$(printf '%s-%s-%s' "$ly" "$lm" "$ld") ;;
  esac

  # end = exclusive end of right point's natural range
  case $rwords in
    1) ry=$(printf '%s' "$rp"); ny=$(next_year "$ry" 1); end=$(printf '%s-01-01' "$ny") ;;
    2) ry=$(printf '%s' "$rp" | awk '{print $1}'); rm=$(printf '%s' "$rp" | awk '{print $2}')
       read ny nm <<EOF
$(next_month "$ry" "$rm" 1)
EOF
       end=$(printf '%s-%s-01' "$ny" "$nm") ;;
    3) ry=$(printf '%s' "$rp" | awk '{print $1}'); rm=$(printf '%s' "$rp" | awk '{print $2}'); rd=$(printf '%s' "$rp" | awk '{print $3}')
       read ny nm nd <<EOF
$(next_day "$ry" "$rm" "$rd")
EOF
       end=$(printf '%s-%s-%s' "$ny" "$nm" "$nd") ;;
  esac

  printf '[%s,%s)\n' "$start" "$end"
  exit 0
fi

# ---------------------------------------------------------------------------
# Single point
# ---------------------------------------------------------------------------

parsed=$(parse_point "$trimmed") || { printf 'could not parse date: %s\n' "$trimmed" >&2; exit 1; }
point_to_range "$parsed"
printf '\n'
