# dotfiles

Personal macOS configuration files. Clone this repo on a fresh Mac and run a few commands to get a fully configured development environment.

## Structure

```
.dotfiles/
├── Makefile              # Main entry point (make install, make brew, etc.)
├── bootstrap.sh          # Pulls latest changes, inits submodules, creates symlinks
├── brew_itself.sh        # Installs Homebrew and Oh My Zsh
├── Brewfile              # All Homebrew formulae and casks
├── macos.sh              # macOS system preferences and security hardening
├── git/
│   ├── .gitconfig        # Git config with delta pager (symlinked to ~)
│   └── .gitignore_global # Global gitignore (symlinked to ~)
├── ghostty/
│   └── config            # Ghostty terminal config (symlinked to ~/.config/ghostty/)
├── starship/
│   └── starship.toml     # Starship prompt config (symlinked to ~/.config/)
├── shell/
│   └── .hushlogin        # Suppresses "Last login" message (symlinked to ~)
└── zsh/
    ├── .zshrc            # Main shell config (symlinked to ~)
    └── custom/
        ├── aliases.zsh   # Custom aliases (auto-loaded by Oh My Zsh)
        ├── path.zsh      # PATH modifications (auto-loaded by Oh My Zsh)
        ├── functions/
        │   └── git_remerge   # Autoloaded shell function
        └── plugins/
            ├── zsh-autosuggestions/     # (git submodule)
            └── zsh-syntax-highlighting/ # (git submodule)
```

## Fresh Mac Setup

### 1. Install Xcode Command Line Tools

```sh
xcode-select --install
```

### 2. Clone this repo

```sh
git clone git@github.com:mathifonseca/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 3. Install Homebrew and Oh My Zsh

```sh
./brew_itself.sh
```

This installs [Homebrew](https://brew.sh) and [Oh My Zsh](https://ohmyz.sh).

### 4. Install everything

```sh
make install
```

This runs all steps in order:
- Initializes git submodules (zsh-autosuggestions, zsh-syntax-highlighting)
- Creates symlinks (`.zshrc`, `.gitconfig`, `.hushlogin`, Ghostty config, Starship config)
- Installs all Homebrew packages and casks
- Applies macOS system preferences and security hardening

Or run individual steps:

```sh
make bootstrap  # just submodules + symlinks
make brew       # just Homebrew packages
make macos      # just macOS preferences
make symlinks   # just symlinks
```

### 5. Post-setup

**Node.js** is managed via [nvm](https://github.com/nvm-sh/nvm), not Homebrew. After setup:

```sh
nvm install --lts
```

**Restart your terminal** (or `source ~/.zshrc`) to pick up all changes.

## Manual Steps

Some things can't be automated:

- Add user home folder to Finder sidebar
- Delete unused tags in Finder
- Set up collapsible Dock
- Sign in to apps (1Password, Chrome, Slack, Spotify, etc.)
- Enable FileVault if not already on (System Settings > Privacy & Security > FileVault)

## What Gets Installed

### Homebrew Formulae

| Category | Packages |
|---|---|
| Modern macOS tools | coreutils, moreutils, findutils, binutils, bash, zsh, wget, curl, gnu-sed, gnu-tar, gnupg, git, vim, grep, openssh, screen, gmp |
| System utilities | rename, tree, pstree, mas, htop, pidof, watch |
| Modern CLI replacements | bat, eza, fd, ripgrep, fzf, git-delta, zoxide, jq, tlrc |
| Dev tools | awscli, starship, graphviz, go, gh |
| Fonts | woff2 |

### Modern CLI Replacements

These tools replace classic Unix commands with faster, more user-friendly alternatives:

| Tool | Replaces | What it does |
|---|---|---|
| [bat](https://github.com/sharkdp/bat) | `cat` | Syntax highlighting, line numbers, git integration |
| [eza](https://github.com/eza-community/eza) | `ls` | Icons, colors, git status, tree view |
| [fd](https://github.com/sharkdp/fd) | `find` | Simpler syntax, respects `.gitignore`, much faster |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | `grep` | Blazing fast recursive search, `.gitignore`-aware |
| [fzf](https://github.com/junegunn/fzf) | — | Fuzzy finder for files, history, processes |
| [delta](https://github.com/dandavison/delta) | `diff` | Beautiful syntax-highlighted git diffs |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | `cd`/`z` | Learns your most used directories |
| [jq](https://github.com/jqlang/jq) | — | JSON processor |
| [tlrc](https://github.com/tldr-pages/tlrc) | `man` | Community-driven simplified man pages |

Aliases are configured so classic command names use the modern tools:

| You type | Runs |
|---|---|
| `cat` | `bat` |
| `ls` | `eza` |
| `ll` | `eza -alh --group-directories-first --icons` |
| `tree` | `eza --tree --level=2` |
| `diff` | `delta` |

`fd`, `rg`, `fzf`, `jq`, and `tldr` are used by their own names. `zoxide` replaces the `z` command automatically.

### Casks (GUI Apps)

| Category | Apps |
|---|---|
| Terminal | Ghostty |
| Browsers | Google Chrome |
| Chat | WhatsApp, Zoom, Granola, Slack |
| Desktop | Shottr, The Unarchiver, BetterZip, Calendr |
| Security | 1Password, NordVPN |
| Text / Notes | Notion, Sublime Text, Zed |
| Dev | Zulu (JDK), Postman, SourceTree, Docker Desktop, Linear, Bruno |
| Fonts | Fira Code |
| Fun | Spotify, VLC, EA, Steam |

## Shell Setup

### Oh My Zsh Plugins

| Plugin | What it does |
|---|---|
| git | Git aliases and functions |
| web-search | Search Google/DuckDuckGo from the terminal |
| dirhistory | Navigate directory history with keyboard shortcuts |
| history | History command shortcuts |
| macos | macOS-specific utilities (e.g. `ofd`, `pfd`) |
| brew | Homebrew aliases |
| zsh-syntax-highlighting | Real-time command syntax highlighting |
| zsh-autosuggestions | Fish-like autosuggestions |

### Custom Aliases

| Alias | Command | Description |
|---|---|---|
| `gs` | `git status` | Git status |
| `ga` | `git add ../..` | Git add from two levels up |
| `gpl` | `git pull` | Git pull |
| `gps` | `git push` | Git push |
| `g` | `git` | Short git |
| `s` | `subl .` | Open current dir in Sublime Text |
| `o` | `open .` | Open current dir in Finder |
| `ip` | `dig +short myip.opendns.com @resolver1.opendns.com` | Show public IP |
| `copyssh` | `pbcopy < ~/.ssh/id_rsa.pub` | Copy SSH public key |
| `zshconfig` | `subl ~/.zshrc` | Edit zsh config |

### Custom Functions

| Function | Description |
|---|---|
| `fuckdocker` | Stop and remove all Docker containers and images |
| `git_remerge [branch]` | Checkout main (or given branch), pull latest, switch back, and merge. Handy for keeping feature branches up to date. |

### Key Bindings

| Shortcut | Action |
|---|---|
| `Ctrl+R` | Fuzzy search command history (fzf) |
| `Ctrl+T` | Fuzzy find files (fzf) |
| `Option+F` | Move cursor forward one word |
| `Option+B` | Move cursor backward one word |

### Prompt

Uses [Starship](https://starship.rs) cross-shell prompt with custom config:

- Directory path (truncated to git root)
- Git branch + status + lines added/removed
- Language versions (Node, Go, Java) shown when relevant
- Command duration for slow commands (>2s)
- Current time on the right side

### Terminal

Uses [Ghostty](https://ghostty.org) with:

- Chalk theme
- Fira Code font (size 14)
- Slight transparency with background blur
- Non-blinking bar cursor
- Auto-copy on select
- Tab/split state restored on restart

## Git Config

Versioned at `git/.gitconfig`, symlinked to `~/.gitconfig`:

- [delta](https://github.com/dandavison/delta) as the pager (side-by-side, line numbers, syntax highlighting)
- `zdiff3` conflict style for clearer merge conflicts
- SourceTree as difftool/mergetool
- Global gitignore (`.DS_Store`, `*~`)

## macOS Preferences

The `macos.sh` script configures system-wide preferences via `defaults write`. Here's what it touches:

| Area | Key settings |
|---|---|
| **System** | Show hidden files, disable boot sound, enable firewall + stealth mode, expand save panels, metric units, custom date format |
| **Security** | Firewall stealth mode, AirDrop disabled, Handoff disabled, Siri disabled, crash reporter suppressed, FileVault check |
| **Trackpad** | Tap to click enabled |
| **Keyboard** | Disable Option+Space non-breaking space |
| **Screen** | Password required immediately after sleep |
| **Finder** | No animations, show extensions/status bar/path bar, list view, search current folder, screenshots to ~/Pictures/Screenshots |
| **Safari** | Privacy hardened: no search suggestions to Apple, no AutoFill, no plugins/Java, block popups, Do Not Track, Safe Browsing |
| **Chrome** | Block third-party cookies, disable search suggestions/telemetry/AutoFill/password manager, Safe Browsing, disable backswipe |
| **Arc** | Same privacy/security settings as Chrome |
| **Terminal** | UTF-8 only |
| **Activity Monitor** | Show all processes, sort by CPU, CPU icon in Dock |
| **Photos** | Disable auto-open on device plug-in |
| **Messages** | Disable spell checking |

## Inspiration

- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
- [dnsmichi/dotfiles](https://gitlab.com/dnsmichi/dotfiles)
- [driesvints/dotfiles](https://github.com/driesvints/dotfiles)
