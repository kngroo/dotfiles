# Dotfiles

My shell, Git, and agent configuration. Git tracks the files, GNU Stow links selected
files into my home directory, and a coding agent handles setup for the machine it's on.

## Set up or repair a machine

Give an agent this prompt:

```text
Set up my dotfiles from https://github.com/kngroo/dotfiles.
Use a persistent local checkout, then read AGENTS.md and docs/setup.md.
Inspect this machine and compare its existing configuration before making changes.
Preserve newer working settings. Apply the relevant parts, validate them, and leave
a local setup record with the changes, skipped items, and rollback instructions.
```

The same prompt works for a new machine or an existing setup that has drifted.
If the agent can't clone the repo, clone it yourself into a permanent location and
start the agent there. Don't link files from a temporary checkout.

## How it works

Each Stow package mirrors paths under `$HOME`. For example,
`zsh/.zshrc` becomes `~/.zshrc`. Once linked, editing either path changes the same
file. Review `git diff` and commit changes from this repo.

[Setup guide](docs/setup.md) explains discovery, conflicts, verification, and rollback.
[Agent configuration](docs/agents.md) lists the portable settings and what stays local.

The shell files are an older Oh My Zsh / Powerlevel10k setup. They aren't a snapshot
of my current Mac. An agent should reconcile them with a working machine before
applying them. The Brewfile is an inventory to review, not a command to install every app.

This repo is public. Credentials, company instructions, machine state, and session
history stay outside it. Global agent settings are selected preferences, not a full
backup of `~/.codex` or `~/.claude`.
