#!/usr/bin/env bash
# Claude Code status line: directory | ctx: <pct> | session: <5h quota> | weekly: <7d quota>

input=$(cat)

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
  ctx_str=$(printf "%.0f%%" "$ctx_pct")
else
  ctx_str="—"
fi

# --- Session (5-hour) quota ---
session_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
if [ -n "$session_pct" ]; then
  session_str=$(printf "%.0f%%" "$session_pct")
else
  session_str="—"
fi

# --- Weekly (7-day) quota ---
weekly_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
if [ -n "$weekly_pct" ]; then
  weekly_str=$(printf "%.0f%%" "$weekly_pct")
else
  weekly_str="—"
fi

printf "%s | ctx: %s | session: %s | weekly: %s" "$dir" "$ctx_str" "$session_str" "$weekly_str"
