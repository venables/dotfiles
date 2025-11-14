.PHONY: install banner brew symlink asdf zsh

install: banner brew symlink asdf llms zsh
	@echo "✨ Installation complete!"

banner:
	@echo ""
	@echo "█▀▀▄ █▀▀█ ▀▀█▀▀ █▀▀▀ ▀█▀ █░░░ █▀▀▀ █▀▀▀"
	@echo "█░░█ █░░█ ░░█░░ █▀▀░ ░█░ █░░░ █▀▀▀ ▀▀▀█"
	@echo "▀▀▀▀ ▀▀▀▀ ░░▀░░ ▀░░░ ▀▀▀ ▀▀▀▀ ▀▀▀▀ ▀▀▀▀"
	@echo ""

brew:
	@./scripts/brew.sh

symlink:
	@./scripts/symlink.sh

asdf:
	@./scripts/asdf.sh

llms:
	@./scripts/llms.sh

zsh:
	@./scripts/zsh.sh
