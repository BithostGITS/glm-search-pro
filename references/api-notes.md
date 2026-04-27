# Zhipu GLM Web Search MCP — API Reference

## MCP Endpoint

```
https://open.bigmodel.cn/api/mcp-broker/proxy/web-search/mcp?Authorization=<YOUR_API_KEY>
```

- **Transport**: SSE (Server-Sent Events)
- **Auth**: API key passed as URL query parameter `Authorization=`
- **Do NOT use**: `https://open.bigmodel.cn/api/mcp/web_search_prime/mcp` (deprecated; `tools/call` returns 401)

## Available Tools

| Tool Name         | Description                          | Engine         |
|-------------------|--------------------------------------|----------------|
| `webSearchPro`    | Full-featured search (recommended)   | Zhipu + multi  |
| `webSearchSogou`  | Sogou engine                         | Sogou          |
| `webSearchQuark`  | Quark engine                         | Quark          |
| `webSearchStd`    | Standard search                      | Zhipu          |

### Common Parameters (all tools)

| Parameter                | Type   | Required | Default  | Description                                      |
|--------------------------|--------|----------|----------|--------------------------------------------------|
| `search_query`           | string | ✅       | —        | Search text (recommend ≤70 chars)                 |
| `count`                  | int    | ❌       | 10       | Number of results (1-50)                          |
| `search_recency_filter`  | string | ❌       | noLimit  | `noLimit`, `oneYear`, `oneMonth`, `oneWeek`, `oneDay` |
| `content_size`           | string | ❌       | medium   | `medium` (400-600 chars) or `high` (up to 2500 chars) |
| `search_domain_filter`   | string | ❌       | —        | Restrict to specific domain, e.g. `www.example.com` |

### Response Format

```json
[
  {
    "refer": "ref_1",
    "title": "Page Title",
    "link": "https://example.com/page",
    "media": "Source Name",
    "content": "Page summary/abstract...",
    "icon": "https://sfile.chatglm.cn/searchImage/...",
    "publish_date": "2026-04-27"
  }
]
```

## Prerequisites

- Zhipu API key from <https://open.bigmodel.cn>
- `mcporter` CLI: `npm i -g mcporter`
- Network access to `open.bigmodel.cn`

## Fallback / Degradation

If the MCP endpoint is unreachable or returns errors, the agent may fall back to other available web search providers. Common issues:

- **401 / "Api key not found"**: Wrong endpoint — use the `mcp-broker/proxy` URL, not the old `web_search_prime` endpoint.
- **"Tool not found: web_search_prime"**: The broker endpoint uses different tool names (`webSearchPro`, etc.).
- **Empty results `[]`**: Verify your Zhipu account plan supports web search; check quota at <https://open.bigmodel.cn>.

## Official Docs

- Web Search overview: <https://docs.bigmodel.cn/cn/guide/tools/web-search>
- MCP Server docs: <https://docs.bigmodel.cn/cn/coding-plan/mcp/search-mcp-server>
