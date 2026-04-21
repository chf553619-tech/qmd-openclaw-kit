# Example collections manifest

This repo does not replace QMD's own collection storage.
Instead, it documents a recommended baseline set for OpenClaw deployments.

## Suggested collections

- `workspace-root` → `~/.openclaw/workspace` with `*.md`
- `workspace-memory` → `~/.openclaw/workspace/memory` with `**/*.md`
- `openclaw-docs` → `~/.openclaw/workspace/docs` with `**/*.md`
- `custom-skills` → `~/.openclaw/custom/skills` with `**/*.md`
- `bundled-skills` → `~/.local/lib/node_modules/openclaw/skills` with `**/*.md`
- `bundled-docs` → `~/.local/lib/node_modules/openclaw/docs` with `**/*.md`
- `workspace-projects` → `~/.openclaw/workspace/projects` with `**/*.md`
- `upstream-qmd` → `~/.openclaw/workspace/external/qmd` with `**/*.md`

Use `scripts/bootstrap-collections.sh` to create these quickly.
