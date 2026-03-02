# MCP Servers

This directory contains the MCP (Model Context Protocol) server configuration template.

## Configured Servers

| Server | Type | Purpose | Requires |
|--------|------|---------|---------|
| `playwright` | Local (stdio) | Browser automation, UI testing, web scraping demos | `npm install -g @playwright/mcp` |
| `azure-mcp` | Local (stdio) | Azure resource management from within Copilot | Azure service principal or `az login` |
| `context7` | HTTP (remote) | Real-time library documentation lookup | Nothing — free public server |

> **Note:** The GitHub MCP server is built into Copilot CLI and does not need to be configured here.

## Setup

Run `setup.ps1` (Windows) or `setup.sh` (Mac/Linux) from the repo root — it handles copying this config and filling in secrets from Azure Key Vault.

To set up manually:
1. Copy `mcp-config.template.json` to `~/.copilot/mcp-config.json`
2. Replace all `${PLACEHOLDER}` values with your actual credentials
3. Run `/mcp show` inside a Copilot session to verify

## Adding New MCP Servers

Find community MCP servers at [github.com/mcp](https://github.com/mcp).

Add entries to `mcp-config.template.json` using placeholders for any secrets, and document them in the table above.
