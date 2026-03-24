.PHONY: install bootstrap brew macos submodules symlinks

install: submodules symlinks brew macos
	@echo "All done! Restart your terminal."

bootstrap: submodules symlinks
	@echo "Done! Restart your terminal or run: source ~/.zshrc"

submodules:
	git submodule init
	git submodule update

symlinks:
	ln -sf "$(CURDIR)/zsh/.zshrc" "$(HOME)/.zshrc"
	ln -sf "$(CURDIR)/shell/.hushlogin" "$(HOME)/.hushlogin"
	ln -sf "$(CURDIR)/git/.gitconfig" "$(HOME)/.gitconfig"
	ln -sf "$(CURDIR)/git/.gitignore_global" "$(HOME)/.gitignore_global"
	mkdir -p "$(HOME)/.config/ghostty"
	ln -sf "$(CURDIR)/ghostty/config" "$(HOME)/.config/ghostty/config"
	ln -sf "$(CURDIR)/starship/starship.toml" "$(HOME)/.config/starship.toml"
	mkdir -p "$(HOME)/.claude"
	ln -sf "$(CURDIR)/.claude/CLAUDE.md" "$(HOME)/.claude/CLAUDE.md"
	ln -sf "$(CURDIR)/.claude/settings.json" "$(HOME)/.claude/settings.json"
	ln -sf "$(CURDIR)/.claude/sdlc.md" "$(HOME)/.claude/sdlc.md"

brew:
	brew bundle --verbose

macos:
	./macos.sh
