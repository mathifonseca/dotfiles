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

echo "Done! Restart your terminal or run: source ~/.zshrc"
