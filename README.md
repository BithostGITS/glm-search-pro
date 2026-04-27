# glm-web-search

Web search powered by Zhipu GLM's official Web Search MCP server.

An [OpenClaw](https://github.com/openclaw/openclaw) agent skill that provides reliable web search capabilities via Zhipu AI's MCP broker endpoint. Works from China without VPN.

## Features

- 🔍 **Multi-engine search** — Zhipu Pro, Sogou, Quark, and Standard engines
- 🇨🇳 **Works from China** — No VPN required, direct access to Zhipu's servers
- 🔌 **MCP-native** — Uses official MCP protocol via `mcporter` client
- ⚡ **One-command setup** — Auto-detects API key, generates config, verifies connection
- 📦 **ClawHub published** — Install directly via `clawhub install glm-search-pro`

## Prerequisites

1. **Zhipu API key** — Get one for free at [open.bigmodel.cn](https://open.bigmodel.cn)
2. **mcporter CLI** — `npm i -g mcporter`
3. **OpenClaw** (if using as agent skill) — [github.com/openclaw/openclaw](https://github.com/openclaw/openclaw)

## Quick Start

### Option A: Install via ClawHub

```bash
clawhub install glm-search-pro
```

Then run setup:

```bash
bash <install-dir>/glm-web-search/scripts/setup.sh
```

### Option B: Clone this repo

```bash
git clone https://github.com/BithostGITS/glm-search-pro.git
cd glm-web-search
bash scripts/setup.sh
```

### Option C: Manual

```bash
# Set your API key
export ZHIPU_API_KEY="your_api_key_here"

# Run setup
bash scripts/setup.sh
```

## Usage

### As a CLI command

```bash
# Basic search
bash scripts/glm-search "your query"

# With parameters
bash scripts/glm-search "your query" 10 oneWeek high
```

**Parameters:**

| Position | Name          | Default  | Description                                      |
|----------|---------------|----------|--------------------------------------------------|
| 1        | `query`       | —        | Search text (required, ≤70 chars recommended)    |
| 2        | `count`       | 10       | Number of results (1-50)                         |
| 3        | `recency`     | noLimit  | `noLimit`, `oneYear`, `oneMonth`, `oneWeek`, `oneDay` |
| 4        | `content_size` | medium  | `medium` (400-600 chars) or `high` (up to 2500)  |

### As an OpenClaw skill

Once installed, the skill auto-triggers when the agent needs to search the web. Trigger phrases include:

- "search the web", "look up", "find online", "latest news"
- "联网搜索", "在线搜索", "查最新", "搜索一下"

### Direct mcporter usage

```bash
# List available tools
npx -y mcporter --config ~/.openclaw/config/mcporter/mcporter.json list glm-search --schema

# Call directly
npx -y mcporter --config ~/.openclaw/config/mcporter/mcporter.json call glm-search.webSearchPro \
  search_query="your query" count=10 search_recency_filter=noLimit content_size=medium
```

## Available Search Engines

| Tool              | Engine        | Description                          |
|-------------------|---------------|--------------------------------------|
| `webSearchPro`    | Multi-engine  | Best quality, recommended default    |
| `webSearchSogou`  | Sogou         | Sogou search engine                  |
| `webSearchQuark`  | Quark         | Quark search engine                  |
| `webSearchStd`    | Zhipu         | Standard Zhipu search                |

## Response Format

Results are returned as a JSON array. Each item contains:

```json
{
  "refer": "ref_1",
  "title": "Page Title",
  "link": "https://example.com/page",
  "media": "Source Name",
  "content": "Page summary or abstract text...",
  "icon": "https://sfile.chatglm.cn/searchImage/...",
  "publish_date": "2026-04-27"
}
```

## How It Works

```
glm-search (script)
    └── mcporter (MCP client)
        └── Zhipu MCP Broker
            URL: https://open.bigmodel.cn/api/mcp-broker/proxy/web-search/mcp
            Auth: API key via URL query parameter
            └── webSearchPro / webSearchSogou / webSearchQuark / webSearchStd
```

**Key design decisions:**

- Uses Zhipu's **broker/proxy endpoint** (`mcp-broker/proxy/web-search/mcp`), not the deprecated `web_search_prime` endpoint
- API key is passed as URL query parameter (`Authorization=`), not HTTP header — this is Zhipu's requirement for their MCP broker
- The broker endpoint exposes different tool names (`webSearchPro`, etc.) than the old endpoint (`web_search_prime`)

## Troubleshooting

### "Api key not found" (401)

You're likely using the old endpoint. Make sure your mcporter config uses:
```
https://open.bigmodel.cn/api/mcp-broker/proxy/web-search/mcp?Authorization=<YOUR_KEY>
```
NOT: `https://open.bigmodel.cn/api/mcp/web_search_prime/mcp`

### "Tool not found: web_search_prime"

The broker endpoint uses different tool names. Use `webSearchPro` instead of `web_search_prime`.

### Empty results `[]`

- Verify your Zhipu account plan supports web search
- Check quota at [open.bigmodel.cn](https://open.bigmodel.cn)
- Try a different query or engine

## File Structure

```
glm-web-search/
├── SKILL.md                    # Skill definition (OpenClaw / ClawHub)
├── README.md                   # This file
├── scripts/
│   ├── setup.sh                # One-command initialization
│   └── glm-search              # Search CLI wrapper
└── references/
    └── api-notes.md            # Detailed API reference
```

## Official Documentation

- Web Search overview: <https://docs.bigmodel.cn/cn/guide/tools/web-search>
- MCP Server docs: <https://docs.bigmodel.cn/cn/coding-plan/mcp/search-mcp-server>

## License

MIT

## Author

[BithostGITS](https://github.com/BithostGITS)
