#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_ROOT="${WORKSPACE_ROOT:-$HOME/.openclaw/workspace}"
OPENCLAW_HOME="${OPENCLAW_HOME:-$HOME/.openclaw}"
OPENCLAW_SKILLS="${OPENCLAW_HOME}/custom/skills"
BUNDLED_SKILLS="${HOME}/.local/lib/node_modules/openclaw/skills"
BUNDLED_DOCS="${HOME}/.local/lib/node_modules/openclaw/docs"

add_collection() {
  local path="$1"
  local name="$2"
  local mask="$3"
  if [ -d "$path" ]; then
    qmd collection add "$path" --name "$name" --mask "$mask" || true
  else
    printf 'skip missing dir: %s\n' "$path"
  fi
}

add_context() {
  local uri="$1"
  local text="$2"
  qmd context add "$uri" "$text" || true
}

add_collection "$WORKSPACE_ROOT" workspace-root '*.md'
add_collection "$WORKSPACE_ROOT/memory" workspace-memory '**/*.md'
add_collection "$WORKSPACE_ROOT/docs" openclaw-docs '**/*.md'
add_collection "$OPENCLAW_SKILLS" custom-skills '**/*.md'
add_collection "$BUNDLED_SKILLS" bundled-skills '**/*.md'
add_collection "$BUNDLED_DOCS" bundled-docs '**/*.md'
add_collection "$WORKSPACE_ROOT/OpenClaw-Admin" openclaw-admin '**/*.md'
add_collection "$WORKSPACE_ROOT/projects" workspace-projects '**/*.md'
add_collection "$WORKSPACE_ROOT/external/qmd" upstream-qmd '**/*.md'

add_context 'qmd://workspace-root/' 'Main OpenClaw workspace root documents: identity, user profile, tools, soul, heartbeat, operational notes.'
add_context 'qmd://workspace-memory/' 'Session memory and daily notes. Use for recent events, decisions, tasks, and continuity before rereading raw files.'
add_context 'qmd://openclaw-docs/' 'Local workspace docs folder for this OpenClaw environment.'
add_context 'qmd://custom-skills/' 'User custom skills for this OpenClaw installation. Search here for local workflows and custom retrieval habits.'
add_context 'qmd://bundled-skills/' 'Bundled OpenClaw skills. Search here before rereading long skill docs to decide which skill applies.'
add_context 'qmd://bundled-docs/' 'Bundled OpenClaw product documentation and CLI docs. Prefer this for commands, config shape, architecture, and troubleshooting.'
add_context 'qmd://openclaw-admin/' 'Operational notes, deployment docs, issue summaries, and user-facing guides for the OpenClaw-Admin project.'
add_context 'qmd://workspace-projects/' 'Reusable project kits and implementation docs created in the workspace projects directory.'
add_context 'qmd://upstream-qmd/' 'Upstream QMD source tree docs and README. Search here for official behavior, CLI examples, and architecture notes.'

qmd update

echo 'Done. Run qmd embed when you want semantic vectors.'
