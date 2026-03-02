---
applyTo: "**/*.bicep"
---

# Bicep Instructions

- Use **modules** — one module per logical resource group (e.g. `modules/app-service.bicep`)
- Follow Azure naming convention: `{type}-{workload}-{environment}-{region}` (e.g. `app-myapi-prod-aue`)
- Always set **`location`** as a parameter with `resourceGroup().location` as default
- Always set **`tags`** — include at minimum `environment`, `project`, `managedBy`
- Use **`existing`** keyword to reference pre-existing resources rather than hardcoding IDs
- Prefer **Managed Identity** — add `identity: { type: 'SystemAssigned' }` to all compute resources
- Always output resource IDs and endpoints that downstream resources will need
- Use **`@secure()`** decorator on any parameter that holds a secret
- Set `sku` and `kind` explicitly — never rely on defaults
