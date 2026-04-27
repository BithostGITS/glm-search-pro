---
name: glm-web-search
description: >
  Web search via Zhipu GLM official MCP (webSearchPro). Use when the agent needs to
  search the web, look up current information, find news, or retrieve online resources.
  Trigger on: "search the web", "web search", "look up", "find online", "latest news",
  "search for", "google for", "联网搜索", "在线搜索", "查最新", "搜索一下".
  Requires a Zhipu API key; see references/api-notes.md for setup.
---

# glm-web-search

Web search powered by Zhipu GLM's official Web Search MCP server.

## Quick Start

```bash
# First-time setup (prompts for API key if not found):
bash <skill-dir>/scripts/setup.sh

# Search:
bash <skill-dir>/scripts/glm-search "your query"
bash <skill-dir>/scripts/glm-search "your query" 10 oneWeek high
```

## When to Use

- User asks to search the web, find current/online information, or look up news
- Agent needs real-time data not available in local knowledge
- Any scenario requiring web search results (title, URL, snippet)

## Available Search Tools

| Tool              | Use Case                                    |
|-------------------|---------------------------------------------|
| `webSearchPro`    | Default — best quality, multi-engine        |
| `webSearchSogou`  | Sogou engine                                |
| `webSearchQuark`  | Quark engine                                |
| `webSearchStd`    | Standard Zhipu engine                       |

Default tool is `webSearchPro` (used by the `glm-search` script).

## Parameters

- `search_query` (required) — search text, ≤70 chars recommended
- `count` (optional) — 1-50 results, default 10
- `search_recency_filter` — `noLimit` / `oneYear` / `oneMonth` / `oneWeek` / `oneDay`
- `content_size` — `medium` (400-600 chars) or `high` (up to 2500 chars)
- `search_domain_filter` (optional) — restrict to specific domain

## Direct mcporter Usage

```bash
# List available tools:
npx -y mcporter --config ~/.openclaw/config/mcporter/mcporter.json list glm-search --schema

# Call directly:
npx -y mcporter --config ~/.openclaw/config/mcporter/mcporter.json call glm-search.webSearchPro \
  search_query="query" count=10 search_recency_filter=noLimit content_size=medium
```

## Response Format

Results are JSON arrays. Each item contains:
- `title` — page title
- `link` — URL
- `content` — page summary/abstract
- `media` — source name
- `publish_date` — publication date (if available)

## Prerequisites

1. **Zhipu API key** — get one at <https://open.bigmodel.cn>
2. **mcporter** — `npm i -g mcporter`
3. **Run setup** — `bash <skill-dir>/scripts/setup.sh`

## Troubleshooting

See `references/api-notes.md` for detailed API reference and common issues.
