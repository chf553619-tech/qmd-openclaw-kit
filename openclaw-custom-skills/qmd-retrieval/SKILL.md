---
name: qmd-retrieval
description: Use QMD as the first-pass local retrieval layer for markdown-heavy OpenClaw workflows. Trigger when you need to find relevant workspace docs, memory notes, bundled docs, bundled skills, custom skills, or project notes before reading files directly. Prefer this before broad markdown rereads.
---

# QMD Retrieval

## Goal

Reduce token waste by searching local markdown knowledge before opening files.

## Default workflow

1. Use `qmd search` for exact keywords, names, config keys, filenames, or phrases.
2. Use `qmd query` when the question is conceptual and keyword search is weak.
3. Use `qmd --files` or structured output to identify the smallest useful file set.
4. Read only the top files you actually need.
5. Keep broad manual rereads as the fallback, not the default.

## Good targets

- OpenClaw docs
- bundled skills
- custom skills
- workspace docs
- memory markdown
- project READMEs / ops notes

## Practical guidance

- On CPU-only or unstable GPU setups, prefer:
  - `qmd search ...`
  - `qmd query ... --no-rerank`
- Reserve embedding/rerank-heavy workflows for when lexical search is not enough.
- If a collection exists but returns weak results, improve its `qmd context` summary.

## Examples

```bash
qmd search 'gateway status' -c bundled-docs -n 5 --files
qmd search 'GitHub token' -c workspace-root -n 5 --files
qmd query $'lex: "dynamic agents"\nvec: how the dynamic agents issue was fixed' -c openclaw-admin --files
qmd multi-get 'memory/2026-04-2*.md' -l 80
```
