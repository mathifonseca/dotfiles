#!/usr/bin/env bash
# Pulls latest main for every ~/code/claude-* repo backing a symlinked skill.
# Invoked at login + every 24h by launchd, or manually via `claude-skills-update`.
# Uses --ff-only so local uncommitted/divergent work fails loudly instead of being merged.

set -u

CODE_DIR="${HOME}/code"
LOG_PREFIX="[claude-skills-update $(date '+%Y-%m-%d %H:%M:%S')]"

echo "${LOG_PREFIX} starting"

shopt -s nullglob
repos=("${CODE_DIR}"/claude-*)
shopt -u nullglob

if [ ${#repos[@]} -eq 0 ]; then
  echo "${LOG_PREFIX} no claude-* repos found in ${CODE_DIR}"
  exit 0
fi

failed=0
for repo in "${repos[@]}"; do
  [ -d "${repo}/.git" ] || { echo "${LOG_PREFIX} skip ${repo##*/} (not a git repo)"; continue; }

  name="${repo##*/}"
  if out=$(git -C "${repo}" pull --ff-only --quiet 2>&1); then
    echo "${LOG_PREFIX} ok    ${name}"
  else
    echo "${LOG_PREFIX} FAIL  ${name}: ${out}"
    failed=$((failed + 1))
  fi
done

echo "${LOG_PREFIX} done (${#repos[@]} repos, ${failed} failed)"
exit 0
