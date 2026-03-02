---
name: create-architecture-diagram
description: Use this skill when asked to create, draw, design, or visualise an architecture diagram. Produces a .drawio file using Azure Architecture icons via the draw.io MCP server.
---

## When to Use
Use when the user asks:
- "create an architecture diagram"
- "draw a diagram of this system"
- "visualise this architecture"
- "diagram this for me"
- "create a draw.io diagram"
- "show me the architecture as a diagram"

## Prerequisites
The **drawio MCP server** must be connected. If it's not available, tell the user to:
1. Install Deno: https://deno.com
2. Clone the server: `git clone https://github.com/simonkurtz-MSFT/drawio-mcp-server`
3. Set `DRAWIO_MCP_PATH` in their environment and update `~/.copilot/mcp-config.json`

## Process

### Step 1 — Gather requirements
If not already provided, determine:
- **Services/components** involved (e.g. "React frontend, FastAPI backend, Azure SQL, Azure OpenAI")
- **Diagram type**: architecture overview / network topology / data flow / C4 context
- **Output path**: default to `docs/diagrams/<project-name>.drawio`

### Step 2 — Plan layers
Organise components into logical layers before drawing:
- `Client` — browsers, mobile apps, external users
- `Edge` — Front Door, API Gateway, Application Gateway, CDN
- `Compute` — App Service, Container Apps, Functions, AKS
- `Data` — databases, storage, caches
- `AI` — Azure OpenAI, AI Search, Cognitive Services
- `Security` — Key Vault, Managed Identity, Entra ID
- `Observability` — Application Insights, Log Analytics, Monitor
- `Network` — VNets, Subnets, Private Endpoints, NSGs

Only include layers relevant to the described architecture.

### Step 3 — Search for icons
Before adding any Azure service, use `search_shapes` to find the exact icon name.
Never guess icon names — always search first.

### Step 4 — Build the diagram
1. Create the diagram file
2. Add layers
3. Add shapes layer by layer (cluster related components visually)
4. Add connections with protocol/port labels
5. Apply colour coding:
   - Blue `#0078D4` — Azure compute/core services
   - Green `#107C10` — data and AI services  
   - Orange `#D83B01` — security and edge services
   - Grey `#737373` — external/client components

### Step 5 — Confirm output
After saving, tell the user:
- The file path
- How to open it: `code <file>.drawio` (requires VS Code Draw.io extension) or https://app.diagrams.net
- A brief summary of what was drawn

## Rules
- Always use official Azure icons — never use generic rectangles for Azure services
- Keep diagrams focused — if more than ~15 components, split into multiple diagrams
- Add a title text box at the top of every diagram
- Include a legend if using colour coding
