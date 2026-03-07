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

## Things to Avoid

- Do not add `node` or `yarn` to the Brewfile — they conflict with nvm.
- Do not put aliases that override Oh My Zsh defaults in `aliases.zsh` — they'll be overridden. Put them in `.zshrc` after the oh-my-zsh source line.
- Do not use `alias` for commands containing `$(...)` subshells — use a function instead.
- Do not hardcode Homebrew paths to `/usr/local` — Apple Silicon uses `/opt/homebrew`.
- Do not track `.DS_Store` files (covered by `.gitignore`).
