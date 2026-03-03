# Squad Team Roster

This file defines the agent team for this repository. The coordinator reads this file to understand team composition before decomposing and routing work.

## Team Purpose

We are a solutions architect's agent team specialising in Azure cloud solutions, Infrastructure as Code (Terraform and Bicep), AI/ML integrations, and enterprise demos.

---

## Agents

### coordinator
**Role:** Orchestrator  
**File:** `.github/agents/coordinator.agent.md`  
**Use when:** The task spans multiple domains, or you're unsure which specialist to pick. The coordinator decomposes the request and fans out via `/fleet`.

---

### azure-architect
**Role:** Azure Infrastructure Specialist  
**File:** `.github/agents/azure-architect.agent.md`  
**Domains:** Bicep, ARM, azd, Azure networking, Managed Identity, RBAC, Key Vault, Container Apps, AKS, App Service, Azure Monitor  
**Use when:** Designing or implementing Azure infrastructure, setting up azd projects, configuring RBAC, or reviewing Azure architecture.

---

### terraform-engineer
**Role:** Terraform / IaC Specialist  
**File:** `.github/agents/terraform-engineer.agent.md`  
**Domains:** Terraform HCL, Azure provider (`azurerm`/`azuread`), module design, remote state (Azure Blob), GitHub Actions Terraform pipelines, Checkov/tfsec security scanning  
**Use when:** Writing or reviewing Terraform, designing module structure, setting up remote state, or building Terraform CI/CD pipelines.

---

### demo-builder
**Role:** Demo and Prototype Specialist  
**File:** `.github/agents/demo-builder.agent.md`  
**Domains:** Rapid prototypes, client-ready demos, end-to-end runnable apps, setup scripts, `.env.example` files  
**Use when:** Building something that needs to run from a fresh clone in under 5 minutes, or preparing a demo for a client meeting.

---

### presales
**Role:** Presales and Client Presentation Specialist  
**File:** `.github/agents/presales.agent.md`  
**Domains:** Client-facing storytelling, visual impact, pitch decks, architecture narratives, POC framing  
**Use when:** Preparing for a client presentation, building a POC with storytelling intent, or framing technical work as business value.

---

### code-reviewer
**Role:** Code Review and Security Specialist  
**File:** `.github/agents/code-reviewer.agent.md`  
**Domains:** Security vulnerabilities, Azure anti-patterns, logic bugs, correctness, Terraform misconfigurations  
**Use when:** Reviewing code or IaC for issues — only surfaces high-signal findings (bugs, security, correctness), never style.

---

### diagram-architect
**Role:** Architecture Diagram Specialist  
**File:** `.github/agents/diagram-architect.agent.md`  
**Domains:** Excalidraw diagrams (default), draw.io (on request), Azure architecture diagrams  
**Use when:** Creating or updating architecture diagrams, visualising system designs.

---

## Working With the Team

- **Single domain task** → Pick the relevant specialist directly from the agent picker
- **Multi-domain task** → Use `coordinator` — it will decompose and `/fleet` to the right people
- **Unsure** → Use `coordinator` — it will ask clarifying questions and route appropriately
- **Architecture decisions** → Log them in `.squad/decisions.md` for future sessions
