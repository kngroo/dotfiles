# Working on these dotfiles

Read `docs/setup.md` before provisioning, repairing, or linking configuration.
Read `docs/packages.md` for package dependencies and platform choices.
Read `docs/agents.md` before changing global agent configuration.

Inspect the actual environment. Preserve existing working configuration and resolve
conflicts file by file. Don't assume this repo is newer than the machine.
Proceed with reversible work within the user's request; ask only for missing intent,
credentials, or a destructive choice that can't be resolved from context.

This repository is public. Add only reviewed files. Never import whole agent config
directories, private work instructions, credentials, or session data. Preserve local
integrations when merging settings. Don't change permissions or trust policy as a
side effect of importing preferences.

Keep setup knowledge in the guides rather than adding a universal installer.
Record machine-specific changes in ignored `.local/` files. Update the guides when
the repository's layout or setup requirements change.

All Stow packages live under `packages/`. Use an explicit `--dir=packages`, target,
and `--no-folding`. The two Fastfetch packages are alternatives, never apply both.

Validate changed config syntax and links in a temporary home before touching live
targets. Run `git diff --check`. Never run a shell config merely to syntax-check it.
