# GPU / 后端说明

本集成套件**不会修改上游 QMD**，而是让 OpenClaw 部署中的后端选择更可预测。

## 推荐策略

- 如果你明确知道该用什么后端，就直接显式设置 `QMD_LLAMA_GPU`
- 否则使用本仓库自带包装脚本，它会按以下顺序选择：
  - 只有在 NVIDIA 用户态条件 **且 CUDA Toolkit 可用** 时才用 `cuda`
  - 检测到 `vulkaninfo` 和 `glslc` 时用 `vulkan`
  - 否则回落到 `false`（CPU 模式）

## 为什么这在 WSL 下重要

很多带 NVIDIA 透传的 WSL 环境会出现这种情况：

- `nvidia-smi` 能用
- `/dev/dxg` 存在
- 但 Vulkan 构建依赖并不完整，例如缺少：
  - `libvulkan-dev`
  - `vulkan-tools`
  - `glslc`
  - `glslang-tools`

这时自动探测常常会不断尝试一个实际上坏掉的 Vulkan 路径，最后再回退到 CPU。

## 稳定优先

一个稳定的 CPU 路径，通常比反复失败的 GPU 自动探测更有价值。
如果你的系统还没准备好 CUDA / Vulkan，可以直接强制：

```bash
export QMD_LLAMA_GPU=false
```

## Ubuntu / WSL 常见 Vulkan 依赖

```bash
sudo apt-get update
sudo apt-get install -y libvulkan-dev vulkan-tools glslc glslang-tools
```

## CUDA 前提

包装脚本只做最小可用性判断。真正的 CUDA 支持通常还需要：

- 支持 WSL GPU 的 NVIDIA Windows 驱动
- WSL 内能看到 `libcuda.so`
- 当 node-llama-cpp 需要本地构建 CUDA 后端时，还需要 CUDA Toolkit / `nvcc`

## 已验证的 WSL CUDA 结果

这一套流程已经在一台带 NVIDIA GeForce RTX 3050 Ti Laptop GPU 的 WSL 主机上实测打通。在安装 CUDA Toolkit 后，验证结果包括：

- `nvcc` 可用
- `libcudart` / `libcublas` / `libcuda` 可见
- `QMD_LLAMA_GPU=cuda qmd status` 显示：
  - `GPU: cuda (offloading: yes)`
  - 能识别 NVIDIA 设备名
  - 能读取 VRAM 信息
- QMD MCP wrapper 可在 CUDA 路径上成功重启

## 验证方式

```bash
QMD_LLAMA_GPU=cuda qmd status
QMD_LLAMA_GPU=vulkan qmd status
QMD_LLAMA_GPU=false qmd status
```

选那个既快、又能稳定复现的模式即可。
