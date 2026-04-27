---
name: glm-search-pro
description: >
  Web search via Zhipu GLM — supports both MCP (mcporter) and cURL (REST API) backends.
  Provides multi-engine search (Pro, Sogou, Quark, Std) with intent recognition, time range
  filtering, domain filtering, and configurable result count/detail level.
  Use when the agent needs to search the web, look up current information, find news,
  or retrieve online resources. Works from China without VPN.
  Trigger on: "search the web", "web search", "look up", "find online", "latest news",
  "search for", "google for", "联网搜索", "在线搜索", "查最新", "搜索一下".
metadata:
  {
    "openclaw":
      {
        "requires": { "env": ["ZHIPU_API_KEY"], "bins": ["curl"] },
      },
  }
---

# GLM Search Pro

Web search powered by Zhipu GLM, with dual-backend support: **MCP** (via mcporter) and **cURL** (REST API fallback).

## Credentials

This skill requires a **Zhipu API key**. Set it before use:

```bash
export ZHIPU_API_KEY="your-api-key"
```

The API key is **only read from the `ZHIPU_API_KEY` environment variable**. It is never hardcoded, never written to disk by this skill, and never embedded in URLs visible in config files. At runtime, the key is passed directly to the API via HTTP `Authorization` header (cURL mode) or as a transient URL parameter to the MCP broker endpoint (MCP mode).

### What this skill writes to disk

| File | Purpose | Permissions |
|------|---------|-------------|
| `~/.openclaw/config/mcporter/mcporter.json` | mcporter server config (URL with API key for MCP broker) | `600` (owner-only) |
| `~/.openclaw/config/mcporter/` directory | Created if missing | `700` (owner-only) |

The setup script (`setup.sh`) is the only component that writes these files. It sets restrictive permissions (`chmod 600/700`) to limit exposure.

### What this skill reads

| Source | When | Purpose |
|--------|------|---------|
| `$ZHIPU_API_KEY` env var | Always (preferred) | Primary API key source |
| `~/.openclaw/config/glm.json` | Only during setup, as fallback | Legacy key location (not read at runtime) |

## Quick Start

```bash
# Set your API key
export ZHIPU_API_KEY="your-api-key"

# Setup (one-time — configures mcporter, sets file permissions)
bash scripts/setup.sh

# Search
bash scripts/glm-search "your query"

# With options
bash scripts/glm-search -q "latest AI news" -c 20 -r oneWeek -e quark
```

## Backends

The script auto-selects the best available backend:

1. **cURL mode** (preferred) — requires only `curl` + `ZHIPU_API_KEY` env var
2. **MCP mode** (advanced) — requires `mcporter` + completed setup

Force a specific mode with `--curl` or `--mcp`.

## Search Engines

| Engine | Flag | Backend | Best For |
|--------|------|---------|----------|
| Pro | `-e pro` | cURL / MCP | General purpose, best quality (**default**) |
| Quark | `-e quark` | cURL / MCP | Advanced scenarios, Chinese content |
| Sogou | `-e sogou` | cURL / MCP | China domestic content |
| Std | `-e std` | cURL / MCP | Basic search, Q&A |

## Parameters

| Flag | Long | Default | Description |
|------|------|---------|-------------|
| `-q` | `--query` | — | Search text (required, ≤70 chars recommended) |
| `-c` | `--count` | 10 | Number of results (1-50) |
| `-e` | `--engine` | pro | `pro`, `sogou`, `quark`, `std` |
| `-r` | `--recency` | noLimit | `noLimit`, `oneYear`, `oneMonth`, `oneWeek`, `oneDay` |
| `-s` | `--size` | medium | `medium` (400-600 chars) or `high` (up to 2500) |
| `-i` | `--intent` | off | Enable search intent recognition (cURL only) |
| `-d` | `--domain` | — | Restrict results to specific domain |
| | `--curl` | — | Force cURL backend |
| | `--mcp` | — | Force MCP backend |

## Examples

```bash
# Basic search
glm-search "OpenClaw framework"

# Recent news, more results
glm-search -q "AI news" -c 20 -r oneWeek

# Chinese content via Sogou
glm-search -q "最新科技新闻" -e sogou -r oneDay

# Domain-specific search
glm-search -q "Python async" -d docs.python.org

# Force cURL mode with intent recognition
glm-search --curl -i "What is machine learning"
```

## Response Format

```json
{
  "id": "task-id",
  "created": 1704067200,
  "search_intent": [{ "query": "...", "intent": "SEARCH_ALL", "keywords": "..." }],
  "search_result": [
    {
      "title": "Page Title",
      "content": "Page summary...",
      "link": "https://example.com",
      "media": "Source Name",
      "icon": "https://...",
      "refer": "ref_1",
      "publish_date": "2026-04-27"
    }
  ]
}
```

## Architecture

```
glm-search (script)
├── cURL mode (preferred)
│   └── curl → Zhipu REST API (/paas/v4/web_search) → search_pro/sogou/quark/std
└── MCP mode (advanced)
    └── mcporter → Zhipu MCP Broker → webSearchPro/Sogou/Quark/Std
```

## Setup

```bash
bash scripts/setup.sh
```

This will:
1. Check for `curl` (required) and `mcporter` (optional)
2. Read API key from `$ZHIPU_API_KEY` environment variable only
3. Generate mcporter config at `~/.openclaw/config/mcporter/mcporter.json` with `600` permissions
4. Verify the connection

## Prerequisites

- **Zhipu API key** — <https://open.bigmodel.cn> (set as `ZHIPU_API_KEY` env var)
- **curl** — pre-installed on most systems
- **mcporter** (optional, for MCP mode) — `npm i -g mcporter`

## Troubleshooting

See `references/api-notes.md` for detailed API reference and common issues.
