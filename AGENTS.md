# Agent Roster

This file documents all custom agents configured for this Copilot CLI setup.
Copilot reads this file automatically from the git root to understand available agents and their responsibilities.

> Agent `.md` files live in `.github/agents/` (repo-level) and are copied globally to `~/.copilot/.github/agents/` by `setup.ps1`.

---

## Agent Directory

| Agent | Model | Purpose |
|---|---|---|
| `coordinator` | `claude-sonnet-4.6` | Orchestrates the full team — decomposes multi-domain tasks and fans out to specialists via `/fleet` |
| `azure-architect` | `claude-sonnet-4.6` | Designs and implements Azure infrastructure with Bicep, azd, Managed Identity, and RBAC |
| `terraform-engineer` | `gpt-5.2-codex` | Writes Terraform HCL modules, manages remote state, builds Terraform CI/CD pipelines |
| `demo-builder` | `gpt-5.2-codex` | Builds fast, client-ready Azure demos runnable in under 10 minutes |
| `presales` | `claude-opus-4.6` | Builds POCs optimised for live client presentations — visual impact and storytelling |
| `code-reviewer` | `gpt-5.3-codex` | Reviews code for security issues, Azure anti-patterns, and correctness bugs only |
| `diagram-architect` | `claude-sonnet-4.6` | Creates and updates architecture diagrams using draw.io with official Azure icons |
| `solution-designer` | `claude-sonnet-4.6` | Produces HLD/LLD design documents, ADRs, and technical specs |
| `python-engineer` | `gpt-5.3-codex` | Python specialist — FastAPI, async, pydantic, Azure SDK, pytest |
| `pipeline-engineer` | `gpt-5.2-codex` | CI/CD pipelines — GitHub Actions and Azure DevOps for Terraform and Python workloads |
| `security-hardening` | `claude-sonnet-4.6` | Cloud security assessments — IAM, network exposure, secrets management, Defender, compliance |

---

## Model Selection Rationale

| Model | Strengths | Best For |
|---|---|---|
| `gpt-5.3-codex` | Sharpest code comprehension and precision | Code review, Python engineering |
| `gpt-5.2-codex` | Fast, high-quality code generation | Demo building, Terraform, pipelines |
| `claude-sonnet-4.6` | Deep reasoning, structured thinking, technical writing | Architecture, security, diagrams, solution design |
| `claude-opus-4.6` | Most nuanced and creative | Presales storytelling, client-facing content |

---

## Routing Rules

When delegating tasks, follow this priority order:

1. If the task spans **multiple domains** → use `coordinator`
2. If the task is **Azure infra / Bicep / azd** → use `azure-architect`
3. If the task is **Terraform** → use `terraform-engineer`
4. If the task is **Python code** → use `python-engineer`
5. If the task is **a demo or POC** → use `demo-builder`
6. If the task is **a client presentation** → use `presales`
7. If the task is **code review** → use `code-reviewer`
8. If the task is **a diagram** → use `diagram-architect`
9. If the task is **a design doc / HLD / LLD** → use `solution-designer`
10. If the task is **CI/CD pipelines** → use `pipeline-engineer`
11. If the task is **security hardening** → use `security-hardening`

---

## Maintenance

**Update this file whenever:**
- A new agent is added or removed
- An agent's model assignment changes
- An agent's responsibilities change significantly
