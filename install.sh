#!/usr/bin/env bash
# Applies packages from this repo. Read MANIFEST.md first — this script is
# just the direct execution of what that file describes, nothing more.
#
# Usage:
#   ./install.sh              install the default package set
#   ./install.sh nvim tmux    install only the named packages
#   ./install.sh --list       print available package names and exit
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

DEFAULT_PACKAGES=(git bash tmux starship nvim fastfetch cava local-bin)
ALL_PACKAGES=(git bash tmux starship nvim fastfetch cava local-bin vim)

if [[ "${1:-}" == "--list" ]]; then
    printf '%s\n' "${ALL_PACKAGES[@]}"
    exit 0
fi

OS="linux"
[[ "$(uname -s)" == "Darwin" ]] && OS="macos"

pkg_install() {
    if [[ "$OS" == "macos" ]]; then
        command -v brew &>/dev/null && brew install "$@" || echo "  (brew not found, skipping: $*)"
    else
        # DEBIAN_FRONTEND=noninteractive avoids apt/needrestart hanging on an
        # interactive debconf prompt (e.g. "which services should be
        # restarted?") when there's no TTY to answer it - a well-known cause
        # of CI runs stalling indefinitely on `apt-get install`.
        command -v apt-get &>/dev/null && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$@" || echo "  (apt-get not found, skipping: $*)"
    fi
}

if ! command -v stow &>/dev/null; then
    echo "GNU Stow not found, installing it (required to apply any package)..."
    pkg_install stow
fi

stow_package() {
    local pkg="$1"
    # Back up any real (non-symlink) file already at a target path this
    # package would occupy, instead of letting stow refuse outright - so a
    # pre-existing config (e.g. a default ~/.gitconfig or ~/.bashrc) is kept,
    # not silently lost or fought over.
    while IFS= read -r -d '' src; do
        local rel="${src#packages/"$pkg"/}"
        local target="$HOME/$rel"
        if [[ -e "$target" && ! -L "$target" ]]; then
            echo "  backing up existing $target -> $target.pre-dotfiles-backup"
            mv "$target" "$target.pre-dotfiles-backup"
        fi
    done < <(find "packages/$pkg" -type f -print0)
    stow -d packages -t "$HOME" "$pkg"
}

install_git() {
    echo "== git =="
    pkg_install git git-delta
    stow_package git
}

install_bash() {
    echo "== bash =="
    if [[ "$OS" == "macos" ]]; then
        pkg_install eza bat fd duf
    else
        pkg_install eza bat fd-find duf
        mkdir -p "$HOME/.local/bin"
        command -v batcat &>/dev/null && ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
        command -v fdfind &>/dev/null && ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    fi
    stow_package bash
}

install_tmux() {
    echo "== tmux =="
    pkg_install tmux
    stow_package tmux
    if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
    "$HOME/.tmux/plugins/tpm/bin/install_plugins" || echo "  TPM plugin install failed; run ~/.tmux/plugins/tpm/bin/install_plugins manually to retry."
}

install_starship() {
    echo "== starship =="
    pkg_install starship
    stow_package starship
}

# Portable version comparison (no `sort -V`, which is a GNU-only extension
# that macOS's built-in BSD sort doesn't support).
version_lt() {
    local IFS=.
    local -a a=($1) b=($2)
    for i in 0 1 2; do
        local ai=${a[i]:-0} bi=${b[i]:-0}
        (( ai < bi )) && return 0
        (( ai > bi )) && return 1
    done
    return 1
}

# apt's neovim is frequently older than what LazyVim requires (e.g. Debian
# 13 ships 0.10.4; Ubuntu's is similarly behind). Critically, an nvim that's
# too old doesn't fail `Lazy! sync` cleanly - it hangs waiting for a keypress
# ("LazyVim requires Neovim >= X" prompt), which blocks forever in headless
# mode and stalls CI indefinitely rather than erroring. So: don't just warn,
# actually replace it with the prebuilt upstream binary when this happens.
install_prebuilt_nvim() {
    local arch tarball
    case "$(uname -m)" in
        x86_64) arch="x86_64" ;;
        aarch64|arm64) arch="arm64" ;;
        *) echo "  unsupported architecture ($(uname -m)) for prebuilt nvim, skipping"; return 1 ;;
    esac
    tarball="nvim-linux-${arch}.tar.gz"
    echo "  downloading prebuilt nvim ($tarball)..."
    curl -fsSL -o /tmp/nvim-prebuilt.tar.gz \
        "https://github.com/neovim/neovim/releases/latest/download/${tarball}"
    mkdir -p "$HOME/.local/opt/nvim-prebuilt" "$HOME/.local/bin"
    tar xzf /tmp/nvim-prebuilt.tar.gz --strip-components=1 -C "$HOME/.local/opt/nvim-prebuilt"
    ln -sf "$HOME/.local/opt/nvim-prebuilt/bin/nvim" "$HOME/.local/bin/nvim"
    hash -r
}

install_nvim() {
    echo "== nvim =="
    pkg_install neovim
    version="0.0.0"
    command -v nvim &>/dev/null && version="$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')"
    if [[ "$OS" == "linux" ]] && version_lt "$version" "0.11.2"; then
        echo "  apt's nvim ($version) is older than the 0.11.2 LazyVim requires."
        install_prebuilt_nvim
    fi
    stow_package nvim
    if command -v npm &>/dev/null; then
        npm install -g tree-sitter-cli || echo "  npm install -g tree-sitter-cli failed; nvim-treesitter parsers won't build until it's installed manually."
    fi
    if command -v nvim &>/dev/null; then
        # timeout as a safety net: an nvim/plugin issue we haven't seen yet
        # should fail loudly after 5 minutes, not hang the whole install
        # (and CI) indefinitely the way the version mismatch above did.
        timeout 300 nvim --headless "+Lazy! sync" +qa || echo "  Lazy plugin sync failed or timed out; run 'nvim --headless \"+Lazy! sync\" +qa' manually to retry."
    fi
}

install_fastfetch() {
    echo "== fastfetch =="
    pkg_install fastfetch
    stow_package fastfetch
}

install_cava() {
    echo "== cava =="
    pkg_install cava ffmpeg
    stow_package cava
}

install_local_bin() {
    echo "== local-bin =="
    stow_package local-bin
    chmod +x "$HOME/.local/bin/cava-demo" 2>/dev/null || true
}

install_vim() {
    echo "== vim (legacy, not in default set) =="
    pkg_install vim
    stow_package vim
}

targets=("${@:-${DEFAULT_PACKAGES[@]}}")
for pkg in "${targets[@]}"; do
    case "$pkg" in
        git) install_git ;;
        bash) install_bash ;;
        tmux) install_tmux ;;
        starship) install_starship ;;
        nvim) install_nvim ;;
        fastfetch) install_fastfetch ;;
        cava) install_cava ;;
        local-bin) install_local_bin ;;
        vim) install_vim ;;
        *) echo "Unknown package: $pkg (see ./install.sh --list)"; exit 1 ;;
    esac
done

echo
echo "Done. See MANIFEST.md for what each package does and why."
