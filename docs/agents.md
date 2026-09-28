# Global agent configuration

Track portable instructions and selected preferences. An agent should inspect and
merge these into the machine's existing setup, preserving local integrations.

| Repository file | Default destination | Handling |
| --- | --- | --- |
| `agents/.agents/instructions/global.md` | `~/.agents/instructions/global.md` | Stow `agents` |
| `codex/.codex/AGENTS.md` | `~/.codex/AGENTS.md` | Stow `codex` after reconciling existing instructions |
| `claude/.claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | Stow `claude` after reconciling existing instructions |
| `agent-settings/codex.toml` | `~/.codex/config.toml` | Merge supported keys only |
| `agent-settings/claude.json` | `~/.claude/settings.json` | Merge supported keys only |

`agents` is a dependency of both instruction packages. The shared instruction file
contains the portable concision preference. Both agent entry points also tell the
agent to read `~/.agents/instructions/local.md` when present. That optional file is
private and must stay outside this repo.

## Preserve the existing setup

Before replacing a global instruction entry point, compare it with the repository
version. Preserve existing private directives in the local instruction file, including
references to work-specific instructions and installed integration guides. Resolve
relative imports to the correct local paths when moving them. Keep the referenced
files in place. Don't replace the entry point until those references are accounted for.

On a new machine, restore private instructions separately if available. Report missing
private integrations as skipped; the portable instructions should still work without
them. Don't reconstruct company documentation or private skills from conversation
history and publish it here.

Respect `CODEX_HOME` and `CLAUDE_CONFIG_DIR` when set. The Stow packages target the
default paths only. For custom directories, link the individual entry-point files
into the discovered locations and record those paths locally. The entry points use
the user's home directory for shared instructions, independent of the agent directory.

## Settings

The fragments capture selected reasoning-effort preferences from the existing setup.
They intentionally omit model IDs, since account access and supported models vary.
Check the installed version and selected model support before applying those keys.
If a preference isn't supported, leave the working setting and record the omission.

These are inputs for an explicit merge, not automatically loaded override files.
Keep live settings as local regular files because agents may write settings themselves.
Preserve MCP connections, hooks, status lines, plugins, project entries, and unknown
keys. Don't transfer trust decisions, permission grants, environment variables,
authentication, or approval policy as portable defaults.

## Skills and plugins

Restore upstream skills or plugins from their official source using the installed
agent's supported mechanism. Record the source and revision when adding one here.
Don't copy installed plugin directories, generated registries, or caches into Git.
Locally authored skills need a separate review of every included file; examples and
reference material can contain private work even when the main `SKILL.md` is generic.
Only install the skills and integrations requested for that machine.

## Keep local

Credentials and OAuth state, `auth.json`, `.claude.json`, MCP secrets, project trust,
session history, memories, databases, logs, caches, downloaded plugins, permission
rules, machine paths, and work-specific instructions aren't part of this public repo.
The ignore rules are a guardrail, not a substitute for reviewing each added file.

For product behavior, check the installed CLI and current official documentation:
[Codex configuration](https://developers.openai.com/codex/config-basic/),
[Codex instructions](https://developers.openai.com/codex/guides/agents-md/),
[Claude Code settings](https://code.claude.com/docs/en/settings),
[Claude Code memory](https://code.claude.com/docs/en/memory).
