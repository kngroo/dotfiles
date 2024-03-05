ohmyzsh:
	./scripts/ohmyzsh.sh

node:
	./scripts/node.sh

stow:
	stow --verbose --target=$$HOME git
	stow --verbose --target=$$HOME zsh
