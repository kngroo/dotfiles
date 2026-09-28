# Package inventory

All packages live under `packages/`. Nothing is installed by default. Choose the
applicable packages after following [the setup guide](setup.md), then preview with
`stow --dir=packages --no-folding --simulate --verbose --target="$HOME" <names>`.
Use discovered paths if the machine has non-default XDG configuration locations.

| Package | Purpose | Dependencies / follow-up |
| --- | --- | --- |
| `git` | Delta diffs, rebase on pull, diff3 conflicts | Git, Delta, Vim as configured editor; review identity |
| `starship` | Current compact Catppuccin prompt | Starship, Nerd Font for icons; initialize once in the active shell |
| `fastfetch` | Current Mac banner with Apple logo and battery | Fastfetch, Nerd Font; invoke explicitly or through an existing shell hook |
| `fastfetch-headless` | Older generic server banner from PR #1 | Fastfetch; alternative to `fastfetch`, never apply both |
| `nvim` | Current LazyVim setup, extras, custom plugins, lockfile | Neovim with LuaJIT, Git, compiler, tree-sitter CLI; see below |
| `bash` | Optional Bash shell setup from PR #1 | eza, bat, duf for aliases; Starship, zoxide, Fastfetch hooks are conditional |
| `tmux` | Optional Catppuccin tmux with session restore | tmux, Git, TPM and configured plugins; see below |
| `cava-headless` | FIFO audio visualizer from PR #1 | Cava with FIFO support; input at `/tmp/cava.fifo` |
| `local-bin` | Optional `cava-demo` tone/audio feeder | Bash, FFmpeg; pairs with `cava-headless` |
| `vim` | Older plain Vim configuration | Vim; optional alternative to Neovim |
| `zsh` | Historical Oh My Zsh / Powerlevel10k setup | Reconcile before use; not the current Mac shell |
| `agents`, `codex`, `claude` | Shared and agent-specific instructions | See [agent configuration](agents.md); `agents` is required by the other two |

The source captures were reviewed on 2026-09-28. Starship 1.26.0, Fastfetch 2.68.1,
and Neovim 0.12.5 were installed on the source Mac. These are observed versions,
not requirements to upgrade another machine. Check compatibility before applying.
The optional server configs come from PR #1 at commit `6b220cf`.

## Shell and platform choices

Keep the working shell and runtime manager. The current Mac uses Zsh with Starship
and lazy NVM; applying the historical `zsh` package would not reproduce that setup.
For Starship, merge the initialization appropriate to the existing shell and avoid
adding a second prompt initialization. The imported Bash package already initializes
Starship and zoxide if available and runs Fastfetch for each interactive shell.

The Bash aliases expect `bat`, `eza`, and `duf`. Some distributions provide `batcat`
or `fdfind` instead of `bat` or `fd`; adapt aliases or create missing individual
links after checking for conflicts. Don't force-replace binaries. Bash login shells
may need an existing profile to source `.bashrc`; inspect it before changing it.

Choose `fastfetch` for this Mac's display or `fastfetch-headless` for the server
layout. They own the same destination. Neither package adds a shell startup hook.
Preserve existing banner frequency and measure startup time when changing hooks.

`cava-headless` expects a FIFO writer, not system audio capture. Run Cava in one
terminal and `cava-demo` in another to feed a tone, or pass an audio file to the helper.
Check the existing `/tmp/cava.fifo` before use; this older helper uses a fixed path.
Don't apply this package over the Mac's working CoreAudio/tap configuration.

## Neovim

The tracked configuration includes the plugin lockfile, not downloaded plugins,
language servers, undo history, or sessions. Preserve it during setup. Use
`:Lazy restore` to restore locked versions; `:Lazy sync` also updates plugins and
isn't a reproducible restore. Inspect any lockfile change before committing it.
The lazy.nvim bootstrap follows its stable branch, so this isn't a complete pin of
all runtime dependencies. [lazy.nvim command reference](https://lazy.folke.io/usage)

Check [LazyVim's requirements](https://www.lazyvim.org/) against the selected version.
The captured configuration uses fzf, ripgrep, and fd for navigation, a C compiler and
tree-sitter CLI for parsers, and language-specific tools managed through Mason and
the enabled extras. Claude integration needs a separately installed and authenticated
Claude Code; don't copy login state. Lazygit is useful for the Git UI.
Don't change Git's global editor or shell aliases merely because Neovim was imported.

After dependency setup, open Neovim, inspect `:Lazy`, run `:checkhealth`, and test the
enabled language tools. Static CI compiles Lua and parses configuration without
downloading or executing plugins. It does not establish a clean-machine install.
The [cheatsheet](../packages/nvim/.config/nvim/CHEATSHEET.md) records the main mappings.

## tmux

Inspect the installed tmux version and [TPM](https://github.com/tmux-plugins/tpm)
instructions. Reuse an existing TPM install or install it under `~/.tmux/plugins/tpm`,
then install the plugins declared in `.tmux.conf`. Preserve running sessions when
testing. Catppuccin is pinned to `v2.1.3`; the other plugin declarations aren't pinned.
Resurrect captures pane contents and Continuum saves/restores sessions, so their
runtime files stay local. This is an optional server setup, not the Mac's current config.

## Main differences from PR #1

- **Starship:** directory and Git context on the left; duration, Node, Python
  environment, and AWS profile on the right. Keeps the Catppuccin palette, adds icons,
  lowers the duration threshold from 2 seconds to 750 ms, and keeps directory context
  above the repository root. Username/host, Go, Rust, and Docker aren't in the layout.
- **Fastfetch:** the Mac variant adds a colored Apple logo, aligned icon labels,
  battery status, and memory/storage/battery bars. It omits the old GPU, swap, local
  IP, and locale rows. The old generic layout remains available as `fastfetch-headless`.
- **Neovim:** retains the LazyVim bootstrap but adds 17 extras, including Claude Code,
  fzf, Harpoon, Neo-tree, yank history, surround editing, language packs, and sticky
  syntax context. Custom specs add multicursors, undo tree, split/join, Diffview, and
  alignment. Python uses standard checking on open files with inlay hints. Theme
  integrations and the plugin lockfile reflect the current setup; the unused starter
  example is omitted. A company-specific comment was generalized without changing behavior.
