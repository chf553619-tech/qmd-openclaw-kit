# 架构说明

QMD OpenClaw Kit 的刻意设计是：**尽量小，不替代上游 QMD**。
它只负责把 OpenClaw 部署中围绕 QMD 的“运维胶水层”标准化。

## 分层

### 1）上游 QMD

通过 npm 安装：

- 包名：`@tobilu/qmd`
- 命令：`qmd`

职责：

- 本地 BM25 搜索
- 向量搜索
- rerank
- MCP 服务
- collection / context 管理

### 2）本项目

职责：

- 安装辅助脚本
- 面向 WSL / Linux 的后端选择包装层
- 可重复执行的 collection / context 初始化
- OpenClaw MCP 配置模板
- OpenClaw 自定义 skill 模板
- 中英双语复用文档

### 3）OpenClaw 运行时

职责：

- 路由智能体工具调用
- 保持 memory policy 不被破坏
- 可选地通过 MCP 暴露 QMD
- 让智能体在高成本重读前优先使用 QMD

## 设计原则

### 尊重上游

除非确有必要，不建议分叉 QMD。优先做法：

- 用 npm 安装 QMD
- 在本仓库维护包装脚本与模板
- 通过环境变量控制后端策略

### 稳定优先，其次才是“炫”

自动探测出一个坏掉的 GPU 路径，不如一个稳定的 CPU 路径。

推荐策略：

1. 显式设置的 `QMD_LLAMA_GPU` 优先
2. 只有在 CUDA 用户态条件真实满足时才用 CUDA
3. 只有在 Vulkan 工具链真实存在时才用 Vulkan
4. 否则强制回落 CPU

### 检索优先于重读

先用 QMD 缩小范围：

1. `qmd search` / `qmd query`
2. 看命中的文件与路径
3. 只打开真正必要的文档

对节省 token 来说，这通常比单纯追求 GPU 更重要。

## 推荐索引源

对 OpenClaw 场景价值较高的 collections：

- 工作区根目录 markdown
- memory 日志
- docs/
- custom skills
- 内置产品文档
- 内置 skills
- 项目相关文档仓库
- 如果你经常运维 QMD，也建议把上游 QMD 文档纳入

## MCP 模式

推荐在 OpenClaw MCP 配置中调用：

- `scripts/start-qmd-mcp.sh`
- 把后端选择逻辑集中在一个脚本里
- 避免每个入口各自散落策略

## Embedding 策略

如果需要语义检索：

- 优先做定期刷新，而不是每次都全量重建
- CPU 模式下使用保守批次大小
- 把 embeddings 看作维护任务，而不是每轮对话都重跑的动作
