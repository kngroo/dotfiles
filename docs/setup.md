# Agent setup guide

The goal is a working, understandable setup on this machine. Use the repository as
input, inspect the environment, and adapt. There is no universal install command.

## 1. Discover

- Read this guide and `docs/agents.md`. Check `git status` before editing the checkout.
- Find the actual OS, architecture, home directory, shell, installed tools, package
  manager, and application versions. Use `$HOME` and discovered paths, not usernames
  or an assumed Homebrew prefix. Check `CODEX_HOME`, `CLAUDE_CONFIG_DIR`, and
  `XDG_CONFIG_HOME` where relevant.
- Keep the checkout in a permanent user-owned directory. Reuse an existing checkout
  when possible. Don't move or reset a dirty checkout.
- For each relevant target, determine whether it is absent, a regular file, a
  directory, or a symlink. Compare contents and link destinations. An already-correct
  target needs no changes. Don't dump credential files or environment variables.
- Use the user's requested scope. When no scope is given, focus on their current
  shell, Git, and installed coding agents. Don't install every GUI app or enable
  every optional integration.

## 2. Choose what applies

| Source | Destination / handling |
| --- | --- |
| `git/` | Stow package for `.gitconfig`; check identity and Delta availability |
| `zsh/` | Older shell package; reconcile prompt, plugins, NVM, and hardcoded paths first |
| `bash/`, `tmux/`, `vim/` | Optional Stow packages; inspect compatibility with installed versions |
| `agents/`, `codex/`, `claude/` | Selected global instruction files; see `docs/agents.md` |
| `agent-settings/` | Preference fragments to merge, not Stow packages |
| `Brewfile` | Historical macOS package inventory; select needed, available packages |
| `iterm2/` | Legacy app export and color theme; import through the app only if wanted |
| `scripts/changemacaddress` | Unrelated utility; never part of machine setup |

The checked-in Zsh setup still uses Oh My Zsh, Powerlevel10k, eager NVM loading,
and an old absolute user path. Don't replace a newer working Starship or lazy-NVM
setup with these files. Ghostty, Starship, and Fastfetch configs haven't been imported
yet. If the user wants to capture them, review the live files and dependencies first.

On macOS, check the active Homebrew installation before using it. On Linux or WSL,
use the available package manager and skip macOS applications. On native Windows,
don't apply POSIX shell files or Stow commands; configure supported agents directly
and clarify whether a WSL shell setup is wanted.

Inspect installed versions and upstream documentation before installing missing
dependencies. Preserve working versions unless an upgrade is needed. Don't replace
one runtime manager with another or enable automatic version switching incidentally.
For NVM, use documented initialization or a reviewed plugin such as `zsh-nvm` when
lazy loading is wanted. Record its source and revision; don't invent a custom loader.

Explain the concrete changes briefly, then carry out reversible work already covered
by the request. Only ask when a meaningful preference or destructive decision is
unresolved. Authentication may need the user; never copy credentials into Git.

## 3. Reconcile and apply

Back up conflicting live files outside this repository, preserving symlinks and
permissions. Record each original path, backup path, and original link destination
in `.local/setup.md`. Don't put backup contents in that record. Merge useful local
changes before linking; avoid `stow --adopt`, forced symlinks, and recursive copies
of entire config directories.

For reviewed Stow packages, use an explicit target and `--no-folding`. This keeps
directories such as `.codex` local, so future runtime files aren't written into Git.
First test in a temporary home; then preview the same selected packages against the
real home. For example, from the repo root with default agent directories:

```sh
stow --simulate --verbose --no-folding --target="$HOME" agents codex claude
stow --verbose --no-folding --target="$HOME" agents codex claude
```

Only run the second command after inspecting the preview and resolving conflicts.
Don't run `stow *`. These commands assume the default home-relative paths; follow
`docs/agents.md` for custom agent config directories. If Stow isn't suitable, create
individual reviewed links or merge files directly and document the choice.

Preferences in `agent-settings/` require a key-level merge. Preserve all unrelated
settings. Don't overwrite a live settings file with a fragment. On a fresh machine,
a fragment may become the initial settings file after compatibility checks.

## 4. Verify

- Parse changed shell files with `zsh -n` or `bash -n`. Parse JSON and TOML with an
  available parser. Parsing alone doesn't establish application compatibility.
- Verify selected links resolve to the permanent checkout. Repeating the Stow dry
  run should show no changes. Confirm unrelated files and settings remain intact.
- After shell changes, start a new interactive terminal and check prompt, completion,
  expected commands, Node selection, and startup time. Don't run the full shell setup
  in CI or source it just to check syntax.
- After agent changes, use each installed agent's config diagnostics and a fresh
  session to verify settings and instruction discovery. Preserve existing authentication,
  hooks, and integrations. Record manual checks that couldn't be performed.
- Inspect the complete Git diff for local paths, private content, or credentials.
  Run `git diff --check`. Don't report checks as passed when they weren't run.

## 5. Leave a record and a rollback path

Create or update ignored `.local/setup.md` with the date, OS, checkout location,
selected packages, dependency versions, merged keys, backups, validation, and skipped
items. Keep credentials out of this file too. End with the exact next steps, if any.

To undo links, preview `stow --delete --simulate --verbose --target="$HOME"` with the
same selected package names, inspect it, then repeat without `--simulate`. This
removes links, not the repository files. Restore backed-up files only after checking
that doing so won't discard changes made since setup. For merged settings, reverse
only the keys changed by this setup; don't restore a stale whole-file backup blindly.

Useful references: [GNU Stow options](https://www.gnu.org/software/stow/manual/html_node/Invoking-Stow.html),
[Homebrew Bundle](https://docs.brew.sh/Brew-Bundle-and-Brewfile),
[NVM](https://github.com/nvm-sh/nvm), [zsh-nvm](https://github.com/lukechilds/zsh-nvm).
