#!/usr/bin/env bash
# Claude Code status line.
#
# Personal Mac:  dir | ctx: <pct> | session: <5h quota> | weekly: <7d quota>
# Work Mac:      dir | ctx: <pct> | spend: $<used> / $<limit> (<pct>)
#
# Work mode is detected by LocalHostName matching /Wolt/i, and reads spend
# from the locally-running OpenUsage app (https://www.openusage.ai/) via
# its loopback API at 127.0.0.1:6736. Responses are cached for 5 minutes
# in $TMPDIR to avoid blocking the status line on network I/O.

input=$(cat)

# --- ANSI color helper ---
# Pick green/yellow/red based on `value` against `warn` and `crit` thresholds.
# Usage: color_for <value> <warn> <crit>  → prints ANSI start sequence (or empty).
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'
RESET=$'\033[0m'

color_for() {
  awk -v v="$1" -v w="$2" -v c="$3" \
    -v g="$GREEN" -v y="$YELLOW" -v r="$RED" \
    'BEGIN { printf "%s", (v+0 >= c+0 ? r : (v+0 >= w+0 ? y : g)) }'
}

# --- Directory (last 3 segments, $HOME → ~) ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
if [ -n "$cwd" ]; then
  cwd="${cwd/#$HOME/~}"
  dir=$(echo "$cwd" | awk -F'/' '{
    n=NF
    if (n<=3) { print $0 }
    else { print $(n-2)"/"$(n-1)"/"$n }
  }')
else
  dir="?"
fi

# --- Context usage ---
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$ctx_pct" ]; then
  ctx_str="$(color_for "$ctx_pct" 50 80)$(printf "%.0f%%" "$ctx_pct")${RESET}"
else
  ctx_str="—"
fi

# --- Detect mode ---
local_host=$(scutil --get LocalHostName 2>/dev/null || hostname -s 2>/dev/null || true)
if echo "$local_host" | grep -qi 'wolt'; then
  mode="work"
else
  mode="personal"
fi

if [ "$mode" = "work" ]; then
  # --- Extra-usage spend from OpenUsage (cached 5min) ---
  cache_file="${TMPDIR:-/tmp}/openusage-claude.json"
  cache_max_age=300

  cache_fresh=0
  if [ -f "$cache_file" ]; then
    # Portable mtime: GNU stat (-c %Y) shadows BSD stat (-f %m) on macOS with coreutils.
    mtime=$(stat -c %Y "$cache_file" 2>/dev/null || stat -f %m "$cache_file" 2>/dev/null || echo 0)
    if [ "$(($(date +%s) - mtime))" -lt "$cache_max_age" ]; then
      cache_fresh=1
    fi
  fi

  if [ "$cache_fresh" -eq 0 ]; then
    # 1s connect, 2s total — never block the status line on a hung server.
    body=$(curl -sS --max-time 2 --connect-timeout 1 \
      http://127.0.0.1:6736/v1/usage/claude 2>/dev/null || true)
    if [ -n "$body" ] && echo "$body" | jq -e . >/dev/null 2>&1; then
      printf '%s' "$body" > "$cache_file"
    fi
  fi

  spend_str="—"
  if [ -f "$cache_file" ]; then
    extra=$(jq -r '
      (.lines // [])
      | map(select(.label == "Extra usage spent" and .type == "progress"))
      | first
      | if . == null then empty
        else "\(.used)|\(.limit)"
        end
    ' "$cache_file" 2>/dev/null)
    if [ -n "$extra" ]; then
      used="${extra%%|*}"
      limit="${extra##*|}"
      if [ -n "$used" ] && [ -n "$limit" ] && [ "$limit" != "0" ]; then
        pct=$(awk -v u="$used" -v l="$limit" 'BEGIN{printf "%.0f", (u/l)*100}')
        used_fmt=$(awk -v v="$used"  'BEGIN{printf "%.0f", v}')
        lim_fmt=$(awk  -v v="$limit" 'BEGIN{printf "%.0f", v}')
        color=$(color_for "$pct" 70 90)
        spend_str="${color}\$${used_fmt} / \$${lim_fmt} (${pct}%)${RESET}"
      fi
    fi
  fi

  printf "%s | ctx: %s | spend: %s" "$dir" "$ctx_str" "$spend_str"
else
  # --- Personal: session (5h) and weekly (7d) subscription quotas from CC ---
  session_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
  if [ -n "$session_pct" ]; then
    session_str="$(color_for "$session_pct" 50 80)$(printf "%.0f%%" "$session_pct")${RESET}"
  else
    session_str="—"
  fi

  weekly_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
  if [ -n "$weekly_pct" ]; then
    weekly_str="$(color_for "$weekly_pct" 50 80)$(printf "%.0f%%" "$weekly_pct")${RESET}"
  else
    weekly_str="—"
  fi

  printf "%s | ctx: %s | session: %s | weekly: %s" "$dir" "$ctx_str" "$session_str" "$weekly_str"
fi
