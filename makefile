ohmyzsh:
	./scripts/ohmyzsh.sh

stow:
	stow --verbose --target=$$HOME git
	stow --verbose --target=$$HOME zsh