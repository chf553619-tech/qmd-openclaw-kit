# Example: OpenClaw on WSL with NVIDIA GPU

This example is for hosts where:

- `nvidia-smi` works inside WSL
- `/dev/dxg` exists
- but Vulkan may or may not be complete

## Recommended approach

Use the wrapper script and let it choose:

- `cuda` when CUDA userland indicators are present
- `vulkan` when Vulkan tooling is present
- `false` otherwise

## Validation checklist

```bash
nvidia-smi
ls -l /dev/dxg
QMD_LLAMA_GPU=cuda qmd status
QMD_LLAMA_GPU=vulkan qmd status
QMD_LLAMA_GPU=false qmd status
```

## Common WSL issue

You may have GPU passthrough visible but still miss Vulkan build tools:

- `libvulkan-dev`
- `vulkan-tools`
- `glslc`
- `glslang-tools`

In that case, a stable CPU fallback is better than repeated failed auto-detection.
