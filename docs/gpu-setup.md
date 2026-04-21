# GPU / backend setup notes

This integration kit does **not** patch upstream QMD. Instead, it makes backend selection more predictable for OpenClaw deployments.

## Recommended policy

- If you know the correct backend, set `QMD_LLAMA_GPU` explicitly.
- Otherwise use the provided wrapper script, which selects:
  - `cuda` when `nvidia-smi` and `libcuda.so` are present
  - `vulkan` when `vulkaninfo` and `glslc` are present
  - `false` (CPU mode) otherwise

## Why this matters on WSL

On WSL systems with NVIDIA passthrough, it is common to have:

- `nvidia-smi` available
- `/dev/dxg` present
- but missing Vulkan build dependencies such as:
  - `libvulkan-dev`
  - `vulkan-tools`
  - `glslc`
  - `glslang-tools`

In that situation, automatic backend probing may repeatedly try a broken Vulkan path and then fall back to CPU.

## Stable first

A stable CPU path is better than repeatedly failing GPU auto-detection.
If your system is not ready for CUDA/Vulkan, force:

```bash
export QMD_LLAMA_GPU=false
```

## Typical Vulkan packages on Ubuntu / WSL

```bash
sudo apt-get update
sudo apt-get install -y libvulkan-dev vulkan-tools glslc glslang-tools
```

## Typical CUDA prerequisites

The wrapper only checks for minimal userland indicators. Real CUDA support may still require:

- compatible NVIDIA Windows driver with WSL GPU support
- `libcuda.so` visibility inside WSL
- optional CUDA toolkit pieces depending on your backend/build path

## Validation

```bash
QMD_LLAMA_GPU=cuda qmd status
QMD_LLAMA_GPU=vulkan qmd status
QMD_LLAMA_GPU=false qmd status
```

Use whichever mode is both fast **and** repeatably stable on your host.
