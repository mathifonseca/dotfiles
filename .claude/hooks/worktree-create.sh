#!/usr/bin/env bash
# Claude Code WorktreeCreate hook.
# Input on stdin: {"hook_event_name":"WorktreeCreate","cwd":"...","name":"..."}
# Stdout MUST be the absolute path to the created worktree (single line).
# Stderr is for diagnostics. Non-zero exit aborts worktree creation.
set -euo pipefail

INPUT=$(cat)
CWD=$(printf '%s' "$INPUT" | jq -r '.cwd // empty')
NAME=$(printf '%s' "$INPUT" | jq -r '.name // empty')

[ -z "$CWD" ] && CWD="$PWD"
[ -z "$NAME" ] && NAME="anon-$(date +%s)-$$"

# Guard: only act inside a real git working tree. Non-git projects fall through
# to a clear error rather than producing a broken worktree.
if ! git -C "$CWD" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "worktree-create: '$CWD' is not a git working tree; refusing to create worktree" >&2
  exit 1
fi

# Sanitize name to a safe filesystem segment.
SAFE_NAME=$(printf '%s' "$NAME" | tr -cd 'A-Za-z0-9._-')
[ -z "$SAFE_NAME" ] && SAFE_NAME="anon-$(date +%s)-$$"

WORKTREE_DIR="$CWD/.claude/worktrees/agent-$SAFE_NAME"
BRANCH="worktree-agent-$SAFE_NAME"

# Disambiguate collisions deterministically rather than clobbering.
if [ -e "$WORKTREE_DIR" ] || git -C "$CWD" show-ref --verify --quiet "refs/heads/$BRANCH"; then
  SUFFIX=$(date +%s)-$$
  WORKTREE_DIR="${WORKTREE_DIR}-${SUFFIX}"
  BRANCH="${BRANCH}-${SUFFIX}"
fi

mkdir -p "$(dirname "$WORKTREE_DIR")"

# Create worktree on a fresh branch off current HEAD (orchestrator merges later).
git -C "$CWD" worktree add -b "$BRANCH" "$WORKTREE_DIR" HEAD >&2

# Required: emit the absolute path on stdout for the harness.
printf '%s\n' "$WORKTREE_DIR"
