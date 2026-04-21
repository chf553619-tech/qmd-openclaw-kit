# Changelog

All notable changes to this project will be documented in this file.

## [0.1.0] - 2026-04-22

### Added
- Initial bilingual project documentation (`README.md`, `README.zh-CN.md`)
- Architecture notes in English and Chinese
- GPU / WSL deployment notes
- Reusable OpenClaw skill for QMD-first retrieval
- `install-qmd.sh` for user-local QMD installation
- `bootstrap-collections.sh` for OpenClaw-oriented collection/context setup
- `start-qmd-mcp.sh` backend-aware MCP wrapper
- OpenClaw config template and environment example
- Minimal and WSL+GPU examples
- CONTRIBUTING guide
- Basic GitHub Actions CI workflow

### Improved
- Bootstrap flow is safe to rerun
- Repository structure is now ready for open-source reuse

## [0.1.1] - 2026-04-22

### Improved
- Refined CUDA wrapper policy so `cuda` is selected only when NVIDIA userland indicators and CUDA toolkit availability are present
- Documented a verified WSL CUDA success case for QMD on NVIDIA hardware
- Added CUDA verification helper documentation (`docs/check-qmd-cuda.md`)
- Verified GPU-mode embedding generation completed successfully on WSL CUDA (`291` embedded vectors from `125` documents)
- Published a deployment audit summarizing health status, retrieval effectiveness, and estimated token savings (`docs/audit-2026-04-22.md`)
