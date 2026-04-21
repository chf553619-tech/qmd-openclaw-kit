#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_ROOT="${WORKSPACE_ROOT:-$HOME/.openclaw/workspace}"
OPENCLAW_HOME="${OPENCLAW_HOME:-$HOME/.openclaw}"
OPENCLAW_SKILLS="${OPENCLAW_HOME}/custom/skills"
BUNDLED_SKILLS="${HOME}/.local/lib/node_modules/openclaw/skills"
BUNDLED_DOCS="${HOME}/.local/lib/node_modules/openclaw/docs"

require_bin() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'missing required binary: %s\n' "$1" >&2
    exit 1
  fi
}

collection_exists() {
  qmd collection show "$1" >/dev/null 2>&1
}

ensure_collection() {
  local path="$1"
  local name="$2"
  local mask="$3"

  if [ ! -d "$path" ]; then
    printf 'skip missing dir: %s\n' "$path"
    return 0
  fi

  if collection_exists "$name"; then
    printf 'collection exists: %s\n' "$name"
  else
    printf 'creating collection: %s -> %s (%s)\n' "$name" "$path" "$mask"
    qmd collection add "$path" --name "$name" --mask "$mask"
  fi
}

ensure_context() {
  local uri="$1"
  local text="$2"

  qmd context rm "$uri" >/dev/null 2>&1 || true
  qmd context add "$uri" "$text"
}

require_bin qmd

ensure_collection "$WORKSPACE_ROOT" workspace-root '*.md'
ensure_collection "$WORKSPACE_ROOT/memory" workspace-memory '**/*.md'
ensure_collection "$WORKSPACE_ROOT/docs" openclaw-docs '**/*.md'
ensure_collection "$OPENCLAW_SKILLS" custom-skills '**/*.md'
ensure_collection "$BUNDLED_SKILLS" bundled-skills '**/*.md'
ensure_collection "$BUNDLED_DOCS" bundled-docs '**/*.md'
ensure_collection "$WORKSPACE_ROOT/OpenClaw-Admin" openclaw-admin '**/*.md'
ensure_collection "$WORKSPACE_ROOT/projects" workspace-projects '**/*.md'
ensure_collection "$WORKSPACE_ROOT/external/qmd" upstream-qmd '**/*.md'

ensure_context 'qmd://workspace-root/' 'Main OpenClaw workspace root documents: identity, user profile, tools, soul, heartbeat, operational notes.'
ensure_context 'qmd://workspace-memory/' 'Session memory and daily notes. Use for recent events, decisions, tasks, and continuity before rereading raw files.'
ensure_context 'qmd://openclaw-docs/' 'Local workspace docs folder for this OpenClaw environment.'
ensure_context 'qmd://custom-skills/' 'User custom skills for this OpenClaw installation. Search here for local workflows and custom retrieval habits.'
ensure_context 'qmd://bundled-skills/' 'Bundled OpenClaw skills. Search here before rereading long skill docs to decide which skill applies.'
ensure_context 'qmd://bundled-docs/' 'Bundled OpenClaw product documentation and CLI docs. Prefer this for commands, config shape, architecture, and troubleshooting.'
ensure_context 'qmd://openclaw-admin/' 'Operational notes, deployment docs, issue summaries, and user-facing guides for the OpenClaw-Admin project.'
ensure_context 'qmd://workspace-projects/' 'Reusable project kits and implementation docs created in the workspace projects directory.'
ensure_context 'qmd://upstream-qmd/' 'Upstream QMD source tree docs and README. Search here for official behavior, CLI examples, and architecture notes.'

qmd update

echo 'Done. Bootstrap is complete and safe to rerun.'
echo 'Run qmd embed when you want semantic vectors.'
