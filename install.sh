#!/bin/bash

curl -sSL https://sdk.cloud.google.com | bash -s -- --disable-prompts
source ~/google-cloud-sdk/path.bash.inc

echo "$GCLOUD_SERVICE_ACCOUNT_KEY" > /tmp/gcloud-key.json
gcloud auth activate-service-account --key-file=/tmp/gcloud-key.json
gcloud config set project "$GOOGLE_CLOUD_PROJECT"

npm install -g @_davideast/stitch-mcp

mkdir -p ~/.vscode-remote/data/Machine
cat > ~/.vscode-remote/data/Machine/cline_mcp_settings.json <<EOF
{
  "mcpServers": {
    "stitch": {
      "command": "npx",
      "args": ["-y", "@_davideast/stitch-mcp", "proxy"],
      "env": {
        "GOOGLE_CLOUD_PROJECT": "$GOOGLE_CLOUD_PROJECT"
      }
    }
  }
}
EOF

echo "Stitch MCP ready"
