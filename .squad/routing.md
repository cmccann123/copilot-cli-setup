# Squad Routing Rules

The coordinator reads this file to decide which agents handle which work. Rules are listed in priority order — first match wins.

## Routing Table

| Task type | Keywords / signals | Lead agent | Support agents | Parallelism |
|-----------|-------------------|-----------|----------------|-------------|
| Full solution design (infra + app + demo) | "build a solution", "end to end", "full stack" | `coordinator` | `azure-architect`, `terraform-engineer`, `demo-builder`, `code-reviewer` | Infra agents parallel; demo after |
| Azure-native infra (Bicep/azd) | "bicep", "azd", "arm", "azure yaml", "container apps", "aks" | `azure-architect` | `code-reviewer` | Sequential if review needed |
| Terraform IaC | "terraform", "hcl", "tfvars", "modules", "remote state", "tfstate" | `terraform-engineer` | `azure-architect`, `code-reviewer` | azure-architect for resource list first |
| Terraform + Bicep comparison | "should I use terraform or bicep", "iac choice" | `coordinator` | `azure-architect`, `terraform-engineer` | Parallel perspectives |
| Client demo or POC | "demo", "poc", "prototype", "show client", "live in 10 minutes" | `demo-builder` | `presales` | Sequential (demo first, then presales framing) |
| Presales / pitch | "pitch", "deck", "client meeting", "business value", "narrative" | `presales` | `diagram-architect` | Parallel for diagram |
| Architecture diagram | "diagram", "draw", "visualise", "architecture picture" | `diagram-architect` | — | Standalone |
| Code review | "review", "check", "audit", "is this secure", "scan" | `code-reviewer` | — | Standalone |
| Security review | "security", "vulnerabilities", "exposed", "secrets", "rbac" | `code-reviewer` | `azure-architect` | Parallel |
| Azure networking | "vnet", "subnet", "nsg", "private endpoint", "dns", "firewall" | `azure-architect` | `terraform-engineer` | Parallel if Terraform output also needed |
| Azure identity / RBAC | "managed identity", "rbac", "entra", "service principal", "permissions" | `azure-architect` | `terraform-engineer` | Parallel |
| CI/CD pipeline | "github actions", "pipeline", "deploy", "ci cd" | Context-dependent | See below | — |
| Terraform CI/CD | "terraform pipeline", "terraform github actions", "plan apply workflow" | `terraform-engineer` | — | Standalone |
| Azure CI/CD | "azd pipeline", "azure deploy workflow", "bicep deploy" | `azure-architect` | — | Standalone |

## CI/CD Routing Detail

CI/CD requests need context disambiguation:
- **Terraform deploy pipeline** → `terraform-engineer`
- **App deploy to Azure** → `azure-architect`
- **Demo deploy pipeline** → `demo-builder`
- **Full infra + app pipeline** → `coordinator` fans out to both `terraform-engineer` and `azure-architect`

## Parallelism Rules

The coordinator applies these rules when using `/fleet`:

**Always parallel:**
- `azure-architect` and `terraform-engineer` when designing the same solution (Bicep vs Terraform output, or both needed)
- `demo-builder` and `presales` when preparing a client demo with a pitch deck
- `code-reviewer` with any build step (review runs against the output)
- `diagram-architect` with any architecture design step

**Always sequential:**
- `terraform-engineer` must wait for `azure-architect`'s resource list when Terraform modules are being written to match a Bicep design
- `demo-builder` must wait for infrastructure design when the demo depends on specific Azure endpoints
- `presales` framing must wait for `demo-builder` to know what the demo actually does

## Escalation to Coordinator

If any specialist agent encounters scope that spans its domain, it should say:
> "This request also needs [agent name] — recommend routing via coordinator."

The coordinator is always available to re-orchestrate mid-task.
