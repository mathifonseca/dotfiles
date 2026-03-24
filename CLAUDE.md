# CLAUDE.md

This is a personal macOS dotfiles repository. It automates the setup of a new Mac with preferred tools, shell configuration, and system preferences.

## Project Overview

- **Owner:** mathifonseca
- **Purpose:** Version-controlled macOS environment configuration
- **Shell:** Zsh with Oh My Zsh and Starship prompt
- **Terminal:** Ghostty (Chalk theme, Fira Code font)
- **Package manager:** Homebrew (formulae + casks defined in `Brewfile`)
- **Node.js:** Managed via nvm, NOT Homebrew
- **AI assistant:** Claude Code (installed via Homebrew cask, CLI at `~/.local/bin`)
- **Entry point:** `make install` (see `Makefile` for individual targets)

## Key Files

| File | Purpose |
|---|---|
| `Makefile` | Main entry point (`make install`, `make brew`, `make macos`, `make bootstrap`, `make symlinks`) |
| `bootstrap.sh` | Pulls repo, inits git submodules, creates all symlinks |
| `brew_itself.sh` | Installs Homebrew and Oh My Zsh |
| `Brewfile` | Declarative list of all Homebrew packages and casks |
| `macos.sh` | Applies macOS system preferences and security hardening |
| `zsh/.zshrc` | Main shell config (symlinked to `~/.zshrc`) |
| `zsh/custom/aliases.zsh` | Custom aliases (auto-loaded by Oh My Zsh) |
| `zsh/custom/path.zsh` | PATH modifications (auto-loaded by Oh My Zsh) |
| `zsh/custom/functions/` | Autoloaded zsh functions (e.g. `git_remerge`) |
| `git/.gitconfig` | Git config with delta pager (symlinked to `~/.gitconfig`) |
| `git/.gitignore_global` | Global gitignore (symlinked to `~/.gitignore_global`) |
| `ghostty/config` | Ghostty terminal config (symlinked to `~/.config/ghostty/config`) |
| `starship/starship.toml` | Starship prompt config (symlinked to `~/.config/starship.toml`) |
| `shell/.hushlogin` | Suppresses "Last login" message (symlinked to `~/.hushlogin`) |
| `.claude/CLAUDE.md` | Global Claude Code instructions (symlinked to `~/.claude/CLAUDE.md`) |
| `.claude/settings.json` | Claude Code permissions, hooks, MCP config (symlinked to `~/.claude/settings.json`) |
| `.claude/sdlc.md` | Software Development Lifecycle Guide v1.1.0 (symlinked to `~/.claude/sdlc.md`) |
| `.claude/settings.local.json` | Template for project-level deny rules (not symlinked -- copy to projects) |

## Conventions

- Aliases that override Oh My Zsh defaults (ls, cat, tree, diff) MUST go in `.zshrc` after `source $ZSH/oh-my-zsh.sh` — the custom dir loads before OMZ's lib/directories.zsh and path.zsh, so aliases there get overridden.
- Other aliases and functions go in `zsh/custom/aliases.zsh` — Oh My Zsh auto-loads `*.zsh` files from the custom directory.
- New autoloaded functions go in `zsh/custom/functions/` as individual files (one function per file, filename = function name).
- Zsh plugins that are external repos are added as git submodules under `zsh/custom/plugins/`.
- GUI apps are installed as `cask` entries in the `Brewfile`, CLI tools as `brew` entries.
- macOS `defaults write` commands go in `macos.sh`, organized by application/area with section headers.
- The `fuckdocker` alias is defined as a function (not an alias) to avoid subshell evaluation at shell startup.
- Homebrew paths must work on both Intel (`/usr/local`) and Apple Silicon (`/opt/homebrew`) — use `$(brew --prefix ...)` instead of hardcoded paths.
- New config files should be added to `bootstrap.sh` symlinks AND the `symlinks` target in `Makefile`.
- Claude Code files in `.claude/` are symlinked to `~/.claude/`. Only track authored files (CLAUDE.md, settings.json, sdlc.md) -- runtime state (sessions, history, cache, projects/) is machine-specific and managed by Claude Code itself.
- The SDLC guide (`.claude/sdlc.md`) is versioned with semver. When adopting it in a project, reference the version in that project's `CLAUDE.md` (e.g., "SDLC: v1.1.0").

## Claude Code Configuration

The `.claude/` directory contains portable Claude Code configuration that gets symlinked to `~/.claude/`:

- **CLAUDE.md** -- Global instructions loaded in every session (modern CLI tool preferences)
- **settings.json** -- Permissions for allowed shell commands and MCP tools, session hooks (GSD context monitor), status line config
- **sdlc.md** -- Software Development Lifecycle Guide (v1.1.0). A portable, versioned methodology covering change workflow, testing (including frontend performance), documentation, design principles, agent-ready API design, and AI collaboration patterns. Distilled from 5 milestones of production development. Reference it from project `CLAUDE.md` files: `This project follows the [SDLC guide v1.1.0](~/.claude/sdlc.md).`
- **settings.local.json** -- Template for per-project deny rules (blocks AI from reading `.env` files). Copy this into new projects' `.claude/` directories; it is not symlinked globally.

Only authored files are tracked here. Runtime state (`sessions/`, `history.jsonl`, `cache/`, `projects/`) and installed tools (`get-shit-done/`, `agents/`, `hooks/`) are machine-specific and managed by Claude Code itself.

## Things to Avoid

- Do not add `node` or `yarn` to the Brewfile — they conflict with nvm.
- Do not put aliases that override Oh My Zsh defaults in `aliases.zsh` — they'll be overridden. Put them in `.zshrc` after the oh-my-zsh source line.
- Do not use `alias` for commands containing `$(...)` subshells — use a function instead.
- Do not hardcode Homebrew paths to `/usr/local` — Apple Silicon uses `/opt/homebrew`.
- Do not track `.DS_Store` files (covered by `.gitignore`).
