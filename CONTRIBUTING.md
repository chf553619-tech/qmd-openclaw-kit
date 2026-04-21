# Contributing

Thanks for contributing.

## Scope of this repository

This repository is for the **integration layer around upstream QMD** in OpenClaw-style deployments.

Good contributions:

- better docs
- safer shell wrappers
- more portable bootstrap logic
- OpenClaw examples
- troubleshooting notes for WSL / Linux / macOS

Out of scope unless clearly justified:

- vendoring upstream QMD source
- turning this repo into a fork of QMD
- adding host-specific secrets or personal config dumps

## Development guidelines

- keep scripts POSIX-ish Bash where practical
- prefer wrapper logic over patching upstream behavior
- document host assumptions clearly
- preserve bilingual docs when changing user-facing behavior

## Testing

At minimum:

- `bash -n scripts/*.sh`
- rerun `scripts/bootstrap-collections.sh`
- verify README examples still make sense

If you change backend behavior, include:

- expected host conditions
- failure mode addressed
- fallback behavior

## Attribution

Please keep attribution to upstream QMD visible and accurate.
