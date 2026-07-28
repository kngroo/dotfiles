# Dotfiles

Cross-platform, shell-agnostic dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).
Currently: bash + starship, tmux (Catppuccin, resurrect/continuum), Neovim
(LazyVim + Catppuccin), fastfetch, cava.

**Start with [`MANIFEST.md`](MANIFEST.md).** It's the single source of truth —
what each package is, what it depends on, and what (if anything) needs to
happen after stowing it. This README is just an entry point; `install.sh`
does nothing that isn't spelled out there.

## Quick start

```shell
git clone https://github.com/kngroo/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh              # installs the default package set
./install.sh --list       # see all available packages
./install.sh nvim tmux    # install only specific packages
```

Requires `git` (to clone this repo in the first place) — `install.sh`
installs `stow` itself if it's missing, and everything else too, via `apt`
(Linux) or `brew` (macOS).

## Layout

```
packages/       one directory per Stow package; structure mirrors $HOME
legacy-macos/   old Mac/zsh-specific setup, kept but not part of the default install
scripts/        standalone helper scripts not tied to a specific package
MANIFEST.md     what's in this repo and how to apply it — read this first
install.sh      thin script that does exactly what MANIFEST.md describes
```

## Why this structure

Each package is self-contained and independently stow-able, so adding a new
tool means adding a new directory + a new entry in `MANIFEST.md` — no
central templating or parsing logic to fight with. This is meant to be
readable end-to-end by a human *or* an AI coding agent in one pass, so
either can safely extend it later without archaeology.

See [`legacy-macos/README.md`](legacy-macos/README.md) for the previous
Mac-only setup (Homebrew, iTerm2, zsh + oh-my-zsh + Powerlevel10k).
