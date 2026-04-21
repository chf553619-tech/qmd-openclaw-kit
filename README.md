# QMD OpenClaw Kit

[![CI](https://github.com/chf553619-tech/qmd-openclaw-kit/actions/workflows/ci.yml/badge.svg)](https://github.com/chf553619-tech/qmd-openclaw-kit/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![Upstream QMD](https://img.shields.io/badge/Based%20on-QMD-blue)](https://github.com/tobi/qmd)

**A reusable integration kit for turning [QMD](https://github.com/tobi/qmd) into a low-token local retrieval layer for OpenClaw and agent workflows.**

> English | [简体中文](./README.zh-CN.md)

## Overview

- [What this project is](#what-this-project-is)
- [Why this exists](#why-this-exists)
- [Features](#features)
- [Quick start](#quick-start)
- [Docs and examples](#docs-and-examples)
- [Release status](#release-status)
- [Attribution](#attribution)
- [License](#license)

## What this project is

QMD OpenClaw Kit is a thin integration layer built **on top of upstream QMD**.
It does **not vendor or fork QMD**. Instead, it provides:

- a practical installation flow
- a safer backend-selection wrapper for WSL/Linux hosts
- repeatable collection/context bootstrapping
- OpenClaw MCP configuration templates
- an OpenClaw-friendly retrieval skill
- bilingual documentation for reuse

The goal is simple: help an OpenClaw deployment search local markdown knowledge efficiently before paying token costs to reread large files.

## Why this exists

OpenClaw-style agent environments often accumulate:

- workspace docs
- memory logs
- custom skills
- upstream product docs
- project-specific notes

Without a retrieval layer, agents end up rereading long markdown files again and again.
QMD solves local retrieval well; this kit packages the surrounding operational glue.

## Features

- **Upstream-friendly**: installs `@tobilu/qmd` from npm
- **OpenClaw-oriented**: templates for MCP and skill wiring
- **Backend-aware**: wrapper prefers real GPU backends when available, otherwise falls back to stable CPU mode instead of repeatedly crashing into bad autodetection paths
- **Collection bootstrap**: one script to register high-value markdown folders and attach context summaries
- **Bilingual docs**: English + Simplified Chinese
- **Reusable**: designed to be copied into another OpenClaw deployment with minimal edits

## Repository layout

```text
.
├── docs/
├── openclaw-custom-skills/
├── scripts/
└── templates/
```

## Quick start

### 1) Install QMD

```bash
./scripts/install-qmd.sh
```

By default this installs `@tobilu/qmd` into the current user's npm prefix.

### 2) Bootstrap collections and contexts

```bash
WORKSPACE_ROOT="$HOME/.openclaw/workspace" \
OPENCLAW_HOME="$HOME/.openclaw" \
./scripts/bootstrap-collections.sh
```

This registers common OpenClaw knowledge sources such as:

- workspace root markdown
- workspace memory
- local docs
- bundled OpenClaw skills/docs
- custom skills
- optional projects folder

The bootstrap script is designed to be **safe to rerun**:

- existing collections are reused
- collection contexts are refreshed in place
- missing directories are skipped cleanly

### 3) Wire QMD into OpenClaw MCP

See [`templates/openclaw.jsonc`](./templates/openclaw.jsonc).

Recommended pattern:

- install QMD normally
- use `scripts/start-qmd-mcp.sh` as the MCP command
- let the wrapper choose a sane backend mode

### 4) Optional: build embeddings

```bash
QMD_LLAMA_GPU=false qmd embed --max-docs-per-batch 12 --max-batch-mb 8
```

On CPU-only or unstable GPU setups, this is slower but reliable.

## GPU / backend strategy

This kit treats backend selection as an operational concern, not a marketing checkbox.

Priority order:

1. honor an explicit `QMD_LLAMA_GPU`
2. use CUDA when real CUDA userland support is present
3. use Vulkan when Vulkan tooling is actually available
4. otherwise force CPU mode for stability

That avoids a common WSL/headless failure mode where auto-detection keeps attempting broken Vulkan builds.

## OpenClaw skill

A reusable skill lives at:

- [`openclaw-custom-skills/qmd-retrieval/SKILL.md`](./openclaw-custom-skills/qmd-retrieval/SKILL.md)

Its policy is straightforward:

1. search with QMD first
2. read only the files that matter
3. keep token-heavy rereads as a last resort

## Docs and examples

### Core docs

- Architecture: [`docs/architecture.md`](./docs/architecture.md)
- GPU / backend notes: [`docs/gpu-setup.md`](./docs/gpu-setup.md)
- Collections baseline: [`docs/collections.md`](./docs/collections.md)
- Release checklist: [`docs/release-checklist.md`](./docs/release-checklist.md)
- Changelog: [`CHANGELOG.md`](./CHANGELOG.md)

### Examples

- Minimal setup: [`examples/openclaw-minimal`](./examples/openclaw-minimal)
- WSL + NVIDIA notes: [`examples/openclaw-wsl-gpu`](./examples/openclaw-wsl-gpu)

## Project hygiene

- CI workflow: [`.github/workflows/ci.yml`](./.github/workflows/ci.yml)
- Contribution guide: [`CONTRIBUTING.md`](./CONTRIBUTING.md)

## Release status

This repository is now at an initial reusable release stage.

Suggested first tag:

- `v0.1.0`

## Attribution

This project is **based on upstream QMD** by tobi / contributors:

- Upstream repo: <https://github.com/tobi/qmd>

Use this kit together with upstream QMD documentation; do not treat it as a replacement for upstream docs.

## License

MIT for this integration kit.

Upstream QMD remains licensed by its own project and is not relicensed here.
