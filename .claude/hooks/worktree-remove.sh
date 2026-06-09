#!/usr/bin/env bash
# Claude Code WorktreeRemove hook.
# Input on stdin: {"hook_event_name":"WorktreeRemove","cwd":"...","worktree_path":"..."}
# Stdout is ignored. Non-zero exit logs a warning but does not stop the session.
#
# This hook intentionally removes only the worktree directory. The branch is
# preserved unless we can confirm it's empty — the GSD execute-phase
# orchestrator's step 5.5 merges these branches back into the main branch and
# then deletes them itself. Deleting an unmerged worktree-agent-* branch here
# would destroy the agent's commits.
set -euo pipefail

INPUT=$(cat)
WPATH=$(printf '%s' "$INPUT" | jq -r '.worktree_path // empty')
CWD=$(printf '%s' "$INPUT" | jq -r '.cwd // empty')

[ -z "$WPATH" ] && { echo "worktree-remove: missing worktree_path; nothing to do" >&2; exit 0; }
[ -z "$CWD" ] && CWD="$PWD"

# Capture branch name BEFORE removing the worktree directory.
BRANCH=""
if [ -e "$WPATH/.git" ]; then
  BRANCH=$(git -C "$WPATH" rev-parse --abbrev-ref HEAD 2>/dev/null || true)
fi

# Remove the worktree directory. Retry once after `unlock` for locked worktrees.
if ! git -C "$CWD" worktree remove --force "$WPATH" >&2 2>&1; then
  git -C "$CWD" worktree unlock "$WPATH" >&2 2>/dev/null || true
  git -C "$CWD" worktree remove --force "$WPATH" >&2 2>&1 || \
    echo "worktree-remove: failed to remove $WPATH (manual cleanup may be required)" >&2
fi

# Only delete the branch if it has no commits beyond its merge-base with the
# default branch — i.e. the agent made no changes and the orchestrator has
# nothing to merge. Otherwise leave the branch for the orchestrator to merge.
if [ -n "$BRANCH" ] && echo "$BRANCH" | grep -Eq '^worktree-agent-'; then
  # Resolve default branch tolerantly — origin/HEAD may not be set locally,
  # and pipefail would otherwise abort the script on a quiet symbolic-ref miss.
  DEFAULT_BRANCH=""
  if REF=$(git -C "$CWD" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null); then
    DEFAULT_BRANCH="${REF#origin/}"
  fi
  if [ -z "$DEFAULT_BRANCH" ]; then
    DEFAULT_BRANCH=$(git -C "$CWD" rev-parse --abbrev-ref HEAD 2>/dev/null || echo main)
  fi
  BASE=$(git -C "$CWD" merge-base "$BRANCH" "$DEFAULT_BRANCH" 2>/dev/null || true)
  TIP=$(git -C "$CWD" rev-parse "$BRANCH" 2>/dev/null || true)
  if [ -n "$BASE" ] && [ -n "$TIP" ] && [ "$BASE" = "$TIP" ]; then
    git -C "$CWD" branch -D "$BRANCH" >&2 2>/dev/null || true
  fi
fi

exit 0
