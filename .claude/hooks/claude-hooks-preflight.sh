#!/usr/bin/env bash
# Claude Code SessionStart preflight.
#
# Goals:
#   1. Detect dangling hook references — every `command` listed under
#      ~/.claude/settings.json hooks block must point at a script that exists
#      and is executable. (Catches the "settings.json synced from dotfiles but
#      the script wasn't" case.)
#   2. Detect worktree-isolation misconfig — if the current project is a real
#      git working tree, WorktreeCreate/WorktreeRemove hooks should be wired
#      so Agent(isolation="worktree") works even when Claude Code's own git
#      probe disagrees with `git`.
#
# Output: warnings go to stderr (visible in the session banner). Exit 0
# always — preflight never blocks session start.
set -u

SETTINGS_FILE="${HOME}/.claude/settings.json"
[ -r "$SETTINGS_FILE" ] || exit 0

# ---------- 1. dangling hook references ----------
MISSING=()
while IFS= read -r CMD; do
  [ -z "$CMD" ] && continue
  # Strip a `bash`/`sh`/`node`/`python3`/`zsh` wrapper to find the script path.
  SCRIPT=$(printf '%s' "$CMD" | awk '{
    if ($1 ~ /^(bash|sh|node|python3?|zsh)$/) { print $2; exit }
    print $1
  }' | tr -d '"')
  case "$SCRIPT" in
    /*) ;;
    *) continue ;;  # not an absolute path → inline command, skip
  esac
  if [ ! -e "$SCRIPT" ]; then
    MISSING+=("$SCRIPT")
  elif [ ! -x "$SCRIPT" ]; then
    MISSING+=("$SCRIPT (not executable)")
  fi
done < <(jq -r '.hooks // {} | to_entries[] | .value[] | .hooks[]? | select(.type == "command") | .command' "$SETTINGS_FILE" 2>/dev/null)

if [ ${#MISSING[@]} -gt 0 ]; then
  echo "⚠ Claude Code hook misconfiguration — referenced scripts missing or not executable:" >&2
  for m in "${MISSING[@]}"; do echo "    $m" >&2; done
  echo "  Restore the files or edit ~/.claude/settings.json." >&2
fi

# ---------- 2. worktree-isolation misconfig ----------
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$PWD}"
if git -C "$PROJECT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  CREATE_COUNT=$(jq -r '(.hooks.WorktreeCreate // []) | length' "$SETTINGS_FILE" 2>/dev/null || echo 0)
  REMOVE_COUNT=$(jq -r '(.hooks.WorktreeRemove // []) | length' "$SETTINGS_FILE" 2>/dev/null || echo 0)
  if [ "${CREATE_COUNT:-0}" = "0" ] || [ "${REMOVE_COUNT:-0}" = "0" ]; then
    echo "⚠ Git working tree detected at ${PROJECT_DIR} but WorktreeCreate/WorktreeRemove hooks are not configured." >&2
    echo "  Agent(isolation=\"worktree\") will fail if Claude Code's git probe disagrees with \`git\` itself." >&2
    echo "  Fix: add the two hooks to ~/.claude/settings.json (see worktree-create.sh / worktree-remove.sh)." >&2
  fi
fi

exit 0
