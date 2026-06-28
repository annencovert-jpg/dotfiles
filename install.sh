#!/usr/bin/env bash

set -euo pipefail

echo "Setting up Cline and Stitch MCP..."

# Install Cline when the VS Code CLI is available.
if command -v code >/dev/null 2>&1; then
  code --install-extension saoudrizwan.claude-dev --force || true
else
  echo "VS Code CLI is not available yet. Settings Sync should restore Cline."
fi

# Confirm that the GitHub Codespaces secret is available.
if [ -z "${STITCH_API_KEY:-}" ]; then
  echo "STITCH_API_KEY is not available."
  echo "Grant this repository access to the STITCH_API_KEY Codespaces secret."
  exit 0
fi

# Create Cline's actual MCP settings directory.
CLINE_SETTINGS_DIR="$HOME/.vscode-remote/data/User/globalStorage/saoudrizwan.claude-dev/settings"
CLINE_SETTINGS_FILE="$CLINE_SETTINGS_DIR/cline_mcp_settings.json"

mkdir -p "$CLINE_SETTINGS_DIR"

# Write the Stitch MCP configuration.
cat > "$CLINE_SETTINGS_FILE" <<EOF
{
  "mcpServers": {
    "stitch": {
      "command": "npx",
      "args": [
        "-y",
        "@_davideast/stitch-mcp",
        "proxy"
      ],
      "env": {
        "STITCH_API_KEY": "${STITCH_API_KEY}"
      }
    }
  }
}
EOF

chmod 600 "$CLINE_SETTINGS_FILE"

echo "Cline and Stitch MCP configuration is ready."
echo "Reload the Codespace window if Stitch does not immediately appear in Cline."
