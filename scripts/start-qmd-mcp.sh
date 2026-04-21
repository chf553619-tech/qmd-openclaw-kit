#!/usr/bin/env bash
set -euo pipefail

# Prefer explicit choice if provided by the operator.
if [ -n "${QMD_LLAMA_GPU:-}" ]; then
  exec qmd mcp "$@"
fi

have_cuda=0
have_vulkan=0

if command -v nvidia-smi >/dev/null 2>&1 \
  && ldconfig -p 2>/dev/null | grep -q 'libcuda\.so' \
  && ( command -v nvcc >/dev/null 2>&1 || [ -x /usr/local/cuda/bin/nvcc ] || [ -n "${CUDAToolkit_ROOT:-}" ] ); then
  have_cuda=1
fi

if command -v vulkaninfo >/dev/null 2>&1 && command -v glslc >/dev/null 2>&1; then
  have_vulkan=1
fi

if [ "$have_cuda" -eq 1 ]; then
  export QMD_LLAMA_GPU=cuda
elif [ "$have_vulkan" -eq 1 ]; then
  export QMD_LLAMA_GPU=vulkan
else
  export QMD_LLAMA_GPU=false
fi

printf 'QMD_LLAMA_GPU=%s\n' "$QMD_LLAMA_GPU" >&2
exec qmd mcp "$@"
