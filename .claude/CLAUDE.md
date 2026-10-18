# Global Claude Code Settings

## SDLC
When working on any software project, read and follow `~/.claude/sdlc.md` — it defines the development methodology (change workflow, git hygiene, planning, testing, code quality, architecture, observability, and AI collaboration principles).

## Modern CLI Tools
This machine has modern CLI tools installed. When using the Bash tool, prefer:
- `fd` over `find` — faster, simpler syntax, respects .gitignore
- `rg` over `grep` — faster recursive search, respects .gitignore
- `bat` over `cat` — syntax highlighting (useful for showing file contents to user)
- `eza` over `ls` — better formatting, icons, git status
- `jq` for any JSON processing
- `fzf` is available for interactive fuzzy selection
- `delta` is configured as git's diff pager
- `tldr` (via tlrc) for quick command references

## Secrets in worktrees: symlink, never copy
When a git worktree (or any second checkout) needs `.env`, `.env.local` or any other sensitive file
(keys, credentials, service-account JSON, tokens) from the main tree, **symlink it; never copy it**:
`ln -s <main-tree>/<file> <worktree>/<file>`. This keeps one copy on disk, so a rotation reaches every
tree and no stray copy outlives the worktree. Before linking, confirm the worktree's `.gitignore`
covers the file. If a project forbids agents from touching `.env*`, give the user the exact `ln -s`
command to run (e.g. with the `!` prefix) instead of running it. Copy only when the user explicitly
asks for an independent copy. **Exception — a container must read it:** a symlink pointing outside a
Docker bind mount does not resolve inside the container, so use a hard link (`ln <main>/<file>
<worktree>/<file>`, same filesystem). It is still one copy on disk, but it breaks silently if the
original is later replaced rather than edited in place — remove it with the worktree.

@RTK.md
