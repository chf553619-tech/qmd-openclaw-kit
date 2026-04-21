# Local validation helper: check-qmd-cuda.sh

This helper is useful after installing CUDA Toolkit on a WSL host.

It checks:

- `nvcc`
- CUDA libraries
- NVIDIA / WSL GPU visibility
- `QMD_LLAMA_GPU=cuda qmd status`
- QMD MCP restart through the wrapper
- MCP health endpoint

Suggested usage:

```bash
~/.openclaw/workspace/scripts/check-qmd-cuda.sh
```

This script is intentionally kept as a local validation helper and can be adapted into automation later if desired.
