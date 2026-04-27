# glm-search-pro

Web search powered by Zhipu GLM — dual-backend (cURL + MCP), multi-engine, works from China.

An [OpenClaw](https://github.com/openclaw/openclaw) agent skill published on [ClawHub](https://clawhub.ai/bithostgits/glm-search-pro).

## Features

- 🔍 **Dual-backend** — cURL (REST API, preferred) + MCP (via mcporter)
- 🏎️ **Multi-engine** — Pro, Sogou, Quark, Std search engines
- 🇨🇳 **Works from China** — No VPN required
- 🔒 **Security-focused** — API key from env var only, restrictive file permissions, clear audit trail
- ⚡ **One-command setup** — Auto-detects dependencies, verifies connection
- 📦 **ClawHub published** — `clawhub install glm-search-pro`

## Prerequisites

- **Zhipu API key** — Get one at [open.bigmodel.cn](https://open.bigmodel.cn)
- **curl** — Pre-installed on most systems
- **mcporter** (optional, for MCP mode) — `npm i -g mcporter`

## Quick Start

```bash
# Set your API key
export ZHIPU_API_KEY="your-api-key"

# Install via ClawHub
clawhub install glm-search-pro

# Setup (one-time)
bash scripts/setup.sh

# Search
bash scripts/glm-search "your query"
```

## Usage

```bash
# Basic search (auto-selects cURL mode)
glm-search "OpenClaw framework"

# With options
glm-search -q "AI news" -c 20 -r oneWeek -e quark

# Force MCP mode
glm-search --mcp "latest tech"

# With intent recognition (cURL only)
glm-search --curl -i "What is machine learning"
```

**Parameters:**

| Flag | Default | Description |
|------|---------|-------------|
| `-q` / `--query` | — | Search text (required, ≤70 chars) |
| `-c` / `--count` | 10 | Results 1-50 |
| `-e` / `--engine` | pro | `pro`, `sogou`, `quark`, `std` |
| `-r` / `--recency` | noLimit | `noLimit`, `oneYear`, `oneMonth`, `oneWeek`, `oneDay` |
| `-s` / `--size` | medium | `medium` or `high` |
| `-i` / `--intent` | off | Enable intent recognition (cURL only) |
| `-d` / `--domain` | — | Restrict to specific domain |
| `--curl` | — | Force cURL backend |
| `--mcp` | — | Force MCP backend |

## Security

- API key is read **only** from the `ZHIPU_API_KEY` environment variable
- No API key is ever hardcoded in the skill
- Config files are written with `600` permissions (owner-only)
- Setup only accesses `~/.openclaw/config/mcporter/` (no other file reads)
- All network traffic goes to `open.bigmodel.cn` only

See [Security Scan Results](https://clawhub.ai/bithostgits/glm-search-pro) on ClawHub.

## Architecture

```
glm-search (script)
├── cURL mode (preferred)
│   └── curl → Zhipu REST API (/paas/v4/web_search) → search_pro/sogou/quark/std
└── MCP mode (advanced)
    └── mcporter → Zhipu MCP Broker → webSearchPro/Sogou/Quark/Std
```

## File Structure

```
glm-search-pro/
├── SKILL.md                # Skill definition (OpenClaw / ClawHub)
├── README.md               # This file
├── scripts/
│   ├── setup.sh            # One-command initialization
│   └── glm-search          # Search CLI wrapper (cURL + MCP)
└── references/
    └── api-notes.md        # Detailed API reference
```

## License

MIT

## Author

[BithostGITS](https://github.com/BithostGITS)
