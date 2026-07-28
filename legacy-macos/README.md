# Legacy macOS / zsh setup

This is the previous dotfiles setup: Homebrew provisioning, iTerm2 (Dracula
theme), zsh + oh-my-zsh + Powerlevel10k, fzf-tab, and a MAC-address-changer
script. It's **not** part of `install.sh`'s default install — the current
setup (see `../MANIFEST.md`) is bash + starship, cross-platform, no
Homebrew/iTerm2 dependency.

Kept here for reference, and in case you go back to this setup on a Mac.
Nothing in `../packages/` depends on anything in here.

## Contents

- `Brewfile` — Homebrew bundle (includes `stow`, `gh`, `antibody`)
- `image.png` — screenshot of the old iTerm2 + Powerlevel10k prompt
- `iterm2/` — iTerm2 preferences + Dracula color scheme
- `zsh/.zshrc`, `zsh/.p10k.zsh`, `zsh/.fzf.zsh` — oh-my-zsh + Powerlevel10k + fzf config
- `scripts/install.sh` — original Mac bootstrap (installs Homebrew, clones this repo)
- `scripts/ohmyzsh.sh` — installs oh-my-zsh, Powerlevel10k theme, fzf-tab plugin
- `scripts/changemacaddress` — MAC address randomizer, entirely unrelated to shell setup

## To use this instead of the current setup

```shell
brew bundle --file legacy-macos/Brewfile
legacy-macos/scripts/ohmyzsh.sh
stow -d legacy-macos -t "$HOME" zsh
stow -d legacy-macos -t "$HOME" iterm2   # if you want the iTerm2 prefs/theme too
chsh -s "$(command -v zsh)"
```
