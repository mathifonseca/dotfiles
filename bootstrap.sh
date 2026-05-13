#!/bin/zsh

cd ${0:a:h}

git pull origin main

# Initialize and update git submodules (zsh plugins)
git submodule init
git submodule update

# Symlinks
ln -sf "$PWD/zsh/.zshrc" "$HOME/.zshrc"
mkdir -p "$HOME/.config/ghostty" "$HOME/.config"
ln -sf "$PWD/starship/starship.toml" "$HOME/.config/starship.toml"
ln -sf "$PWD/ghostty/config" "$HOME/.config/ghostty/config"
ln -sf "$PWD/shell/.hushlogin" "$HOME/.hushlogin"
ln -sf "$PWD/git/.gitconfig" "$HOME/.gitconfig"
ln -sf "$PWD/git/.gitignore_global" "$HOME/.gitignore_global"

# Claude Code
mkdir -p "$HOME/.claude"
ln -sf "$PWD/.claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
ln -sf "$PWD/.claude/settings.json" "$HOME/.claude/settings.json"
ln -sf "$PWD/.claude/sdlc.md" "$HOME/.claude/sdlc.md"
ln -sf "$PWD/.claude/statusline-command.sh" "$HOME/.claude/statusline-command.sh"

# launchd: skills auto-update (runs at login + every 24h)
mkdir -p "$HOME/Library/LaunchAgents"
ln -sf "$PWD/.claude/launchd/com.mathifonseca.claude-skills-update.plist" "$HOME/Library/LaunchAgents/com.mathifonseca.claude-skills-update.plist"
launchctl unload "$HOME/Library/LaunchAgents/com.mathifonseca.claude-skills-update.plist" 2>/dev/null || true
launchctl load -w "$HOME/Library/LaunchAgents/com.mathifonseca.claude-skills-update.plist"

echo "Done! Restart your terminal or run: source ~/.zshrc"
