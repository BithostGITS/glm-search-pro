# glm-search-pro

Web search powered by Zhipu GLM — dual-backend (cURL + MCP), multi-engine, works from China.

An [OpenClaw](https://github.com/openclaw/openclaw) agent skill published on [ClawHub](https://clawhub.ai/bithostgits/glm-search-pro).

## Features

- 🔍 **Dual-backend** — cURL (REST API, preferred) + MCP (via mcporter)
- 🏎️ **Multi-engine** — Pro, Sogou, Quark, Std search engines
- 🇨🇳 **Works from China** — No VPN required
- 🔒 **Security-first** — cURL mode sends key via Authorization header only; MCP mode documents exactly what it writes and why
- ⚡ **Zero setup for cURL** — Just set `ZHIPU_API_KEY` and go
- 📦 **ClawHub published** — `clawhub install glm-search-pro`

## Quick Start

```bash
# Set your API key (get one at https://open.bigmodel.cn)
export ZHIPU_API_KEY="your-api-key"

# Install
clawhub install glm-search-pro

# Search (cURL mode, no setup needed)
bash scripts/glm-search "your query"

# With options
bash scripts/glm-search -q "latest AI news" -c 20 -r oneWeek -e quark
```

## Usage

```bash
glm-search "OpenClaw framework"              # Basic
glm-search -q "AI news" -c 20 -r oneWeek     # More results, recent
glm-search -q "最新科技新闻" -e sogou -r oneDay  # Chinese via Sogou
glm-search -q "Python async" -d docs.python.org  # Domain-specific
glm-search -i "What is machine learning"     # Intent recognition
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

## Backends

| Mode | Key handling | Disk writes | Dependencies |
|------|-------------|-------------|-------------|
| **cURL** (preferred) | `Authorization: Bearer` header at runtime | None | `curl` + `$ZHIPU_API_KEY` |
| **MCP** (advanced) | URL query param in config file (Zhipu MCP broker requirement) | `~/.openclaw/config/mcporter/mcporter.json` (600) | `mcporter` + `setup.sh` |

## Security

- cURL mode: API key sent via standard `Authorization: Bearer` header, never persisted
- MCP mode: Zhipu's MCP broker requires the key as a URL query parameter — `setup.sh` writes this to a config file with `600` permissions and clearly documents the tradeoff
- Recommendation: Use cURL mode for maximum security; MCP mode is a convenience feature

## Architecture

```
glm-search (script)
├── cURL mode (preferred, zero setup)
│   └── curl + $ZHIPU_API_KEY → Authorization header → Zhipu REST API
└── MCP mode (advanced, requires setup)
    └── mcporter → config from setup.sh → Zhipu MCP Broker SSE
```

## File Structure

```
glm-search-pro/
├── SKILL.md                # Skill definition
├── README.md               # This file
├── scripts/
│   ├── setup.sh            # MCP mode initialization
│   └── glm-search          # Search CLI (cURL + MCP)
└── references/
    └── api-notes.md        # API reference
```

## License

MIT

## Author

[BithostGITS](https://github.com/BithostGITS)
