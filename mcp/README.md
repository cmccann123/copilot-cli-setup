# MCP Servers

This directory contains the MCP (Model Context Protocol) server configuration template.

## Configured Servers

| Server | Type | Purpose | Requires |
|--------|------|---------|---------|
| `playwright` | Local (stdio) | Browser automation, UI testing, web scraping demos | `npm install -g @playwright/mcp` |
| `azure-mcp` | Local (stdio) | Azure resource management from within Copilot | Azure service principal or `az login` |
| `context7` | HTTP (remote) | Real-time library documentation lookup | Nothing — free public server |
| `microsoft-learn` | HTTP (remote) | Official Microsoft/Azure docs — eliminates hallucinations | Nothing — free public server |
| `excalidraw` | Local (stdio) | Clean architecture diagram generation and export | `npm install -g @scofieldfree/excalidraw-mcp` |
| `terraform` | Local (stdio) | HashiCorp official — Terraform registry, provider/module docs, workspace/plan/apply | Docker + optional `TFE_TOKEN` for HCP Terraform |
| `azure-devops` | Local (stdio) | Azure DevOps repos, work items, pipelines, boards | `npm install -g @tiberriver256/mcp-server-azure-devops` + PAT |
| `vault` | Local (stdio) | HashiCorp official — Vault secrets, KV operations | Docker + `VAULT_ADDR` + `VAULT_TOKEN` |

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
