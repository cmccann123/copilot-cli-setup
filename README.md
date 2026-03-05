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
Specialist agents you can invoke with `/agent` inside any Copilot session. All agents are installed globally to `~/.copilot/agents/` by the setup script — available in every directory.

| Agent | Purpose |
|---|---|
| `coordinator` | Orchestrates the full team — decomposes multi-domain tasks and fans out to specialists via `/fleet` |
| `azure-architect` | Designs and implements Azure infrastructure with Bicep, azd, Managed Identity, and RBAC |
| `terraform-engineer` | Writes Terraform HCL modules, manages remote state, builds Terraform CI/CD pipelines |
| `demo-builder` | Builds fast, client-ready Azure demos runnable in under 10 minutes |
| `presales` | Builds POCs optimised for live client presentations — visual impact and storytelling |
| `code-reviewer` | Reviews code for security issues, Azure anti-patterns, and correctness bugs only |
| `diagram-architect` | Creates and updates architecture diagrams using draw.io with official Azure icons |
| `solution-designer` | Produces HLD/LLD design documents, ADRs, and technical specs |
| `python-engineer` | Python specialist — FastAPI, async, pydantic, Azure SDK, pytest |
| `pipeline-engineer` | CI/CD pipelines — GitHub Actions and Azure DevOps for Terraform and Python workloads |
| `security-hardening` | Cloud security assessments — IAM, network exposure, secrets management, Defender, compliance |

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
| **Excalidraw** | stdio (npx) | Clean architecture diagram generation and export | None |
| **Terraform** | stdio (Docker) | HashiCorp official — registry search, provider/module docs, workspace management, plan/apply | `TFE_TOKEN` (HCP Terraform only) |
| **Azure DevOps** | stdio (npx) | Repos, work items, pipelines, boards | `AZURE_DEVOPS_ORG_URL`, `AZURE_DEVOPS_PAT` |
| **Vault** | stdio (Docker) | HashiCorp official — secrets management, KV operations | `VAULT_ADDR`, `VAULT_TOKEN` |

> `context7` and `microsoft-learn` are remote HTTP servers — no local install required.
> `terraform` and `vault` require Docker — no npm install needed.

### Bootstrap Scripts
- `setup.ps1` / `setup.sh` — installs dependencies, copies MCP config, optionally pulls secrets from Azure Key Vault
- `scripts/verify-setup.ps1` — checks everything is correctly configured

---

## 🔌 How MCP Setup Works

Running `setup.ps1` configures MCP in 7 steps:

| Step | What happens |
|------|-------------|
| 1 | Checks prerequisites (PowerShell 6+, Copilot CLI, Azure CLI, Node.js, Docker) |
| 2 | Creates `~/.copilot/` config directory |
| 3 | Copies `mcp/mcp-config.template.json` → `~/.copilot/mcp-config.json` |
| 4 | *(Optional)* Pulls secrets from Azure Key Vault and substitutes `${PLACEHOLDER}` values |
| 5 | Copies agents, skills, and `copilot-instructions.md` to `~/.copilot/` globally |
| 6 | Installs `@playwright/mcp`, `@azure/mcp`, `@scofieldfree/excalidraw-mcp`, and `@tiberriver256/mcp-server-azure-devops` via npm |

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
| `azure-devops-org-url` | Azure DevOps MCP (e.g. `https://dev.azure.com/your-org`) |
| `azure-devops-pat` | Azure DevOps MCP personal access token |
| `tfe-token` | Terraform MCP — HCP Terraform/Enterprise API token |
| `tfe-address` | Terraform MCP — HCP Terraform/Enterprise URL (optional) |
| `vault-addr` | Vault MCP — Vault server address (e.g. `https://vault.example.com`) |
| `vault-token` | Vault MCP — Vault access token |

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
- [Node.js](https://nodejs.org) — for Playwright, Azure MCP, Excalidraw, and Azure DevOps MCP servers
- [Docker](https://www.docker.com) — for Terraform and Vault MCP servers
- Active [GitHub Copilot subscription](https://github.com/features/copilot/plans)
