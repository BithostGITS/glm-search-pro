#!/usr/bin/env bash
# setup.sh — Initialize glm-web-search skill
# Checks prerequisites and generates mcporter config with user's Zhipu API key.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
MCP_DIR="${HOME}/.openclaw/config/mcporter"
MCP_CONFIG="${MCP_DIR}/mcporter.json"

echo "=== glm-web-search setup ==="

# 1. Check mcporter
if ! command -v mcporter &>/dev/null && ! command -v npx &>/dev/null; then
  echo "Error: mcporter or npx is required." >&2
  echo "Install mcporter: npm i -g mcporter" >&2
  exit 1
fi

# 2. Get API key
if [ -n "${ZHIPU_API_KEY:-}" ]; then
  API_KEY="$ZHIPU_API_KEY"
  echo "Using API key from ZHIPU_API_KEY env var."
else
  # Try existing config
  EXISTING=""
  [ -f "$MCP_CONFIG" ] && EXISTING=$(python3 -c "
import json,sys
try:
    c=json.load(open('$MCP_CONFIG'))
    servers=c.get('mcpServers',{})
    gs=servers.get('glm-search',{})
    url=gs.get('url','')
    if 'Authorization=' in url:
        print(url.split('Authorization=')[1].split('&')[0])
except: pass
" 2>/dev/null || true)

  if [ -n "$EXISTING" ]; then
    echo "Found existing API key in mcporter config."
    API_KEY="$EXISTING"
  else
    # Check common zai config
    ZAI_CFG="${HOME}/.openclaw/config/glm.json"
    [ -f "$ZAI_CFG" ] && EXISTING=$(python3 -c "import json;print(json.load(open('$ZAI_CFG')).get('api_key',''))" 2>/dev/null || true)
    if [ -n "$EXISTING" ]; then
      echo "Found API key in $ZAI_CFG."
      API_KEY="$EXISTING"
    else
      echo ""
      echo "Enter your Zhipu API key (get one at https://open.bigmodel.cn):"
      read -r API_KEY
    fi
  fi
fi

if [ -z "$API_KEY" ]; then
  echo "Error: No API key provided." >&2
  exit 1
fi

# 3. Write mcporter config
mkdir -p "$MCP_DIR"

# Merge into existing config or create new
python3 << PYEOF
import json, os

config_path = "$MCP_CONFIG"
api_key = "$API_KEY"

if os.path.exists(config_path):
    with open(config_path) as f:
        config = json.load(f)
else:
    config = {}

if "mcpServers" not in config:
    config["mcpServers"] = {}

config["mcpServers"]["glm-search"] = {
    "type": "sse",
    "url": f"https://open.bigmodel.cn/api/mcp-broker/proxy/web-search/mcp?Authorization={api_key}"
}

with open(config_path, "w") as f:
    json.dump(config, f, indent=2)

print(f"Config written to {config_path}")
PYEOF

# 4. Verify connection
echo ""
echo "Verifying connection..."
RESULT=$(npx -y mcporter --config "$MCP_CONFIG" list glm-search 2>&1) || true
if echo "$RESULT" | grep -q "webSearchPro"; then
  echo "✅ Connection successful. Available tools: webSearchPro, webSearchSogou, webSearchQuark, webSearchStd"
else
  echo "⚠️  Could not verify connection. Check your API key and try:"
  echo "   npx -y mcporter --config $MCP_CONFIG list glm-search"
fi

echo ""
echo "Setup complete. Use: ${SKILL_DIR}/scripts/glm-search \"your query\""
