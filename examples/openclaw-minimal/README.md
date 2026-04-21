# Example: minimal OpenClaw setup

This example assumes:

- OpenClaw already installed
- QMD installed via `scripts/install-qmd.sh`
- you want a lean, stable CPU-first retrieval setup

## Steps

1. Bootstrap collections:

```bash
WORKSPACE_ROOT="$HOME/.openclaw/workspace" \
OPENCLAW_HOME="$HOME/.openclaw" \
./scripts/bootstrap-collections.sh
```

2. Use a conservative MCP wrapper policy:

```json
{
  "mcp": {
    "servers": {
      "qmd": {
        "command": "/ABSOLUTE/PATH/TO/qmd-openclaw-kit/scripts/start-qmd-mcp.sh",
        "args": []
      }
    }
  }
}
```

3. If GPU paths are unstable, force CPU:

```bash
export QMD_LLAMA_GPU=false
```

4. Restart OpenClaw gateway if needed.
