# Architecture

QMD OpenClaw Kit is intentionally small. It does not replace upstream QMD. It standardizes the *operational glue* around QMD for OpenClaw deployments.

## Layers

### 1. Upstream QMD

Installed from npm:

- package: `@tobilu/qmd`
- binary: `qmd`

Responsibilities:

- local BM25 search
- vector search
- reranking
- MCP server
- collection + context management

### 2. This kit

Responsibilities:

- installation helper scripts
- backend selection wrapper for WSL/Linux hosts
- repeatable collection/context bootstrap
- OpenClaw MCP config template
- OpenClaw custom skill template
- bilingual reuse docs

### 3. OpenClaw runtime

Responsibilities:

- route agent tool calls
- keep conversation memory policy intact
- optionally expose QMD over MCP
- let agents use QMD before expensive rereads

## Design principles

### Respect upstream

Do not fork QMD unless you truly need to. Prefer:

- npm install for QMD
- wrappers and templates in this repo
- local environment variables for backend policy

### Stable first, fancy second

A broken auto-detected GPU path is worse than a stable CPU path.

Recommended backend policy:

1. explicit `QMD_LLAMA_GPU` wins
2. CUDA if userland support is genuinely available
3. Vulkan if the Vulkan toolchain is genuinely available
4. else force CPU

### Retrieval before reread

Use QMD to narrow scope first:

1. `qmd search` / `qmd query`
2. inspect files / paths
3. open only the necessary documents

This matters more than raw GPU speed for token savings.

## Suggested indexed sources

High-value collections for OpenClaw-like setups:

- workspace root markdown
- memory logs
- docs/
- custom skills
- bundled product docs
- bundled skills
- project-specific documentation repos
- upstream QMD docs if you actively operate QMD

## MCP pattern

Recommended OpenClaw MCP command:

- use `scripts/start-qmd-mcp.sh`
- let the wrapper decide backend mode
- keep policy centralized in one place

## Embedding policy

If semantic search is needed:

- prefer scheduled refreshes over constant full rebuilds
- on CPU, use conservative batch sizes
- treat embeddings as a maintenance task, not something to rerun every turn
