# Dotfiles manifest

This file is the single source of truth for what's in this repo and how to
apply it. It is meant to be read end-to-end by a human *or* an AI coding
agent before touching anything — `install.sh` does nothing that isn't
described here.

## How it works

Each directory under `packages/` is a **Stow package**: its internal
structure mirrors `$HOME`, and applying it is just

```
stow -d packages -t "$HOME" <package-name>
```

which symlinks its files into place. Stow is idempotent and safe to re-run.
Nothing here depends on macOS or zsh — see `legacy-macos/README.md` for the
old Mac-specific setup, which is kept but excluded from the default install.

## Default install set

Running `./install.sh` with no arguments installs, in this order:
`git`, `bash`, `tmux`, `starship`, `nvim`, `fastfetch`, `cava`, `local-bin`.

`vim` exists but is **not** in the default set (see its entry below).

---

## Packages

### git
- **What it is:** Git config — `delta` as pager/diff-filter (Dracula syntax theme,
  side-by-side diffs), `diff3` conflict style, `rebase` on pull, `autoSetupRemote` on push.
- **Requires:** `git`, `git-delta`
  - apt: `git`, `git-delta` (Debian/Ubuntu package name for the `delta` binary)
  - brew: `git`, `git-delta`
- **Post-install:** none.

### bash
- **What it is:** `.bashrc` + `.bash_aliases`. Modern CLI replacements
  (`eza`, `bat`, `fd`, `duf`), plus `starship`/`zoxide`/`fastfetch` hooks
  (those three are separate packages below — bash just wires them in if present).
- **Requires:** `eza`, `bat`, `fd-find` (or `fd`), `duf`
  - apt: `eza`, `bat`, `fd-find`, `duf`
  - brew: `eza`, `bat`, `fd`, `duf`
- **Post-install:**
  - On Debian/Ubuntu, `apt`'s `bat`/`fd-find` packages install binaries named
    `batcat`/`fdfind` (name collisions with other packages). The aliases in
    `.bash_aliases` expect plain `bat`/`fd` on `$PATH`, so symlink them:
    ```
    mkdir -p ~/.local/bin
    ln -sf "$(command -v batcat)" ~/.local/bin/bat
    ln -sf "$(command -v fdfind)" ~/.local/bin/fd
    ```
    (Skip this on macOS/Homebrew — the binaries are already named `bat`/`fd`.)

### tmux
- **What it is:** Catppuccin Mocha theme, `tmux-resurrect` + `tmux-continuum`
  (session save/restore, autosave every 15 min, auto-restore on server start),
  mouse mode, vim-tmux-navigator-style pane switching (`C-h/j/k/l` moves
  between tmux panes *or* vim splits seamlessly).
- **Requires:** `tmux` (>= 3.0 recommended for Catppuccin plugin compatibility)
  - apt: `tmux`
  - brew: `tmux`
- **Post-install:**
  ```
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  ~/.tmux/plugins/tpm/bin/install_plugins
  ```

### starship
- **What it is:** Cross-shell prompt (works under bash, zsh, fish — shell-agnostic),
  Catppuccin Mocha colors, git branch/status, language-version modules, command duration.
- **Requires:** `starship`
  - apt: `starship`
  - brew: `starship`
- **Post-install:** none — `bash` package's `.bashrc` already calls
  `starship init bash` if the binary is present.

### nvim
- **What it is:** Neovim + LazyVim + Catppuccin Mocha. `lazy-lock.json` is
  committed on purpose (LazyVim convention) so plugin versions are pinned
  and reproducible across machines.
- **Requires:** Neovim **>= 0.11.2**. Debian/Ubuntu's `apt` package is
  frequently older than this (e.g. Debian 13 "trixie" ships 0.10.4). Critically,
  an nvim that's too old doesn't fail `Lazy! sync` cleanly - it hangs waiting
  for a keypress on a version-mismatch prompt, which blocks forever in
  headless mode (this stalled CI for 9+ minutes before we understood it).
  `install.sh` handles this itself: after installing via apt, it checks
  `nvim --version`, and if it's still too old, downloads the prebuilt
  upstream release into `~/.local/opt/nvim-prebuilt` and symlinks it into
  `~/.local/bin/nvim` (which must be early in `$PATH` - the `bash` package's
  `.bashrc` does this). The Lazy sync step also has a 5-minute `timeout`
  around it as a safety net, in case some other issue causes the same kind
  of hang.
  - apt: `neovim` (version-checked and auto-replaced above if too old)
  - brew: `neovim` (Homebrew stays current, no workaround needed)
- **Requires (runtime, not apt/brew):** Node.js + `npm` (see `scripts/node.sh`),
  used to install the `tree-sitter` CLI, which `nvim-treesitter` needs to
  compile language parsers.
- **Post-install:**
  ```
  npm install -g tree-sitter-cli
  nvim --headless "+Lazy! sync" +qa
  ```

### fastfetch
- **What it is:** System info banner. Config is trimmed to modules that make
  sense on a headless/server box (no display/DE/WM/battery modules) — add
  those back in `config.jsonc` if applying this on a desktop machine.
  Auto-run on shell start is wired into the `bash` package, not here.
- **Requires:** `fastfetch`
  - apt: `fastfetch`
  - brew: `fastfetch`
- **Post-install:** none.

### cava
- **What it is:** Terminal audio visualizer. `fifo` input mode (reads raw PCM
  from `/tmp/cava.fifo`) rather than a live ALSA/PulseAudio/PipeWire capture,
  since it needs to work on headless boxes with no audio server running.
  Catppuccin Mocha gradient colors. Output mode is deliberately `noncurses`,
  not `ncurses` — that's cava's actual default terminal-drawing mode (raw
  ANSI cursor movement); some distro builds (Debian's included) aren't linked
  against libncurses at all, so `method = ncurses` errors on those builds.
- **Requires:** `cava`, `ffmpeg` (ffmpeg is only needed for the `cava-demo`
  test-tone helper in `local-bin`, not for cava itself)
  - apt: `cava`, `ffmpeg`
  - brew: `cava`, `ffmpeg`
- **Post-install:** none. To test: run `cava` in one pane, `cava-demo` in another.

### local-bin
- **What it is:** `~/.local/bin/cava-demo` — feeds a synthetic test tone (or a
  given audio file) into cava's fifo, since there's usually nothing else
  producing live audio on a headless box.
- **Requires:** `ffmpeg` (see `cava` package above).
- **Post-install:** `chmod +x ~/.local/bin/cava-demo` if the executable bit
  didn't survive (Stow preserves it, but check after copying/tarring the repo).

### vim (not in default install set)
- **What it is:** A plain, pre-Neovim `.vimrc`. Superseded by the `nvim`
  package above — kept only for reference/fallback if you ever need plain
  `vim` without the LazyVim stack. Stow it explicitly if you want it:
  `stow -d packages -t "$HOME" vim`.
- **Requires:** `vim`.

---

## Not part of this repo's default path

`legacy-macos/` holds the previous Mac-only setup (Homebrew, iTerm2, zsh +
oh-my-zsh + Powerlevel10k, a MAC-address-changer script). It's excluded from
`install.sh`'s default set on purpose — see `legacy-macos/README.md` before
touching it.
