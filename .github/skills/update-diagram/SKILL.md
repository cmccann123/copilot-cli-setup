---
name: update-diagram
description: Use this skill when asked to update, modify, add to, or change an existing draw.io diagram. Makes targeted changes without redrawing the entire diagram.
---

## When to Use
Use when the user asks:
- "add X to the diagram"
- "update the architecture diagram"
- "change the diagram to include..."
- "remove X from the diagram"
- "the architecture has changed, update the diagram"

## Process

### Step 1 — Locate the diagram file
- Check `docs/diagrams/` first
- If multiple `.drawio` files exist, ask which one to update
- Read the existing diagram XML to understand current state

### Step 2 — Understand the change
Identify whether the request is:
- **Add** — new component, connection, or layer
- **Remove** — delete a shape or connection
- **Modify** — rename, restyle, or move an existing element
- **Restructure** — major layout change (treat as new diagram if >50% changes)

### Step 3 — Make targeted changes
- Use `search_shapes` for any new Azure services being added
- Preserve existing layout — only move shapes if necessary
- Keep consistent styling with existing diagram colours and fonts
- Add new shapes to the appropriate existing layer

### Step 4 — Confirm changes
Summarise exactly what was changed:
- ✅ Added: `<component>`
- ✅ Updated: `<connection>`
- ❌ Removed: `<component>`

## Rules
- Never redraw the whole diagram unless explicitly asked
- Preserve existing shape positions and layer structure
- If the requested change conflicts with the current diagram, explain the conflict before making it
- If the `.drawio` file is not found, fall back to the `create-architecture-diagram` skill
