# copilot-cli-setup

> Best-in-class GitHub Copilot CLI configuration — custom agents, MCP servers, coding instructions, and bootstrap scripts.

Clone this repo and run one script to have a fully configured Copilot CLI session with custom agents, connected MCP tools, and language-specific coding standards.

---

## ⚡ Quick Start

```powershell
# Windows
git clone https://github.com/cmccann123/copilot-cli-setup
cd copilot-cli-setup
.\setup.ps1
```

```bash
# macOS / Linux
git clone https://github.com/cmccann123/copilot-cli-setup
cd copilot-cli-setup
chmod +x setup.sh && ./setup.sh
```

Then verify everything is working:
```powershell
.\scripts\verify-setup.ps1
```

---

## 📦 What's Included

### Custom Agents (`/.github/agents/`)
Specialist agents you can invoke with `/agent` inside any Copilot session:

| Agent | Purpose |
|---|---|
| `demo-builder` | Builds fast, client-ready Azure demos with README and setup scripts |
| `azure-architect` | Designs and implements Azure infrastructure with Bicep and azd |
| `presales` | Builds impressive POCs optimised for live client presentations |
| `code-reviewer` | Reviews code for security, correctness, and Azure best practices |

### Coding Instructions (`/.github/instructions/`)
Language-specific rules automatically applied when Copilot works on matching files:
- `python.instructions.md` — async patterns, Azure SDK, FastAPI structure
- `typescript.instructions.md` — strict types, React Query, Tailwind
- `bicep.instructions.md` — naming conventions, Managed Identity, modules

### MCP Servers (`/mcp/`)
Pre-configured Model Context Protocol servers that connect Copilot to external tools and data:

| Server | Type | Purpose | Auth |
|--------|------|---------|------|
| **Playwright** | stdio (npx) | Browser automation — UI testing, scraping | None |
| **Azure MCP** | stdio (npx) | Azure resource management directly from Copilot | Service principal (Key Vault) |
| **Context7** | HTTP (remote) | Real-time library documentation lookup | None |
| **Microsoft Learn** | HTTP (remote) | Official Microsoft/Azure docs — eliminates hallucinations | None |
| **Draw.io** | stdio (deno) | Diagram generation with 700+ Azure Architecture icons | None (requires Deno + local clone) |

> `context7` and `microsoft-learn` are remote HTTP servers — no local install required.
> `drawio` requires [Deno](https://deno.com) — the setup script clones and configures it automatically.

### Bootstrap Scripts
- `setup.ps1` / `setup.sh` — installs dependencies, copies MCP config, optionally pulls secrets from Azure Key Vault
- `scripts/verify-setup.ps1` — checks everything is correctly configured

---

## 🔌 How MCP Setup Works

Running `setup.ps1` configures MCP in 7 steps:

| Step | What happens |
|------|-------------|
| 1 | Checks prerequisites (PowerShell 6+, Copilot CLI, Azure CLI, Node.js, Deno) |
| 2 | Creates `~/.copilot/` config directory |
| 3 | Copies `mcp/mcp-config.template.json` → `~/.copilot/mcp-config.json` |
| 4 | *(Optional)* Pulls secrets from Azure Key Vault and substitutes `${PLACEHOLDER}` values |
| 5 | Copies agents, skills, and `copilot-instructions.md` to `~/.copilot/` globally |
| 6 | Installs `@playwright/mcp` and `@azure/mcp` via npm |
| 7 | Clones the draw.io MCP server locally and sets `DRAWIO_MCP_PATH` in the config |

The MCP config template is **never overwritten** once copied. Delete `~/.copilot/mcp-config.json` manually to reset.

---

## 🔑 Secrets & Key Vault

Secrets are never committed to this repo. The MCP config template uses `${PLACEHOLDER}` values.

To automatically fill secrets from Azure Key Vault:
```powershell
.\setup.ps1 -KeyVaultName your-keyvault-name
```

Expected secret names in Key Vault:
| Secret Name | Used For |
|---|---|
| `azure-tenant-id` | Azure MCP server auth |
| `azure-client-id` | Azure MCP server auth |
| `azure-client-secret` | Azure MCP server auth |

You must be authenticated (`az login`) with access to the Key Vault.

---

## 🚀 Using the Agents

Inside any Copilot CLI session:
```
/agent
```
Select from the list. Or reference directly in your prompt:
```
Use the demo-builder agent to create an Azure OpenAI streaming chat demo
```

---

## 🔧 Customising for Your Project

Copy the `.github/` folder into any of your project repos to apply these agents and instructions to that project specifically. Customise `copilot-instructions.md` with project-specific context.

---

## 📋 Prerequisites

- PowerShell 6+ (Windows) or bash (macOS/Linux)
- [GitHub Copilot CLI](https://github.com/github/copilot-cli) — `winget install GitHub.Copilot`
- [Azure CLI](https://docs.microsoft.com/cli/azure/) — for Key Vault secrets
- [Node.js](https://nodejs.org) — for Playwright and Azure MCP servers
- [Deno](https://deno.com) — for the draw.io MCP server
- Active [GitHub Copilot subscription](https://github.com/features/copilot/plans)
