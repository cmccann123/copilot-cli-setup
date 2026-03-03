---
name: create-excalidraw-diagram
description: Use this skill when asked to create or draw an architecture diagram using Excalidraw. Produces a professional, clean diagram via the Excalidraw MCP server and saves it as a PNG using Playwright.
---

## When to Use
Use when the user asks:
- "create an excalidraw diagram"
- "draw this architecture in excalidraw"
- "diagram this using excalidraw"
- "make me an architecture diagram and save it as a PNG"
- "create a diagram and export it"

## Prerequisites
- **Excalidraw MCP server** — for drawing
- **Playwright MCP server** — for export only (no iterative verify loop)

---

## ⚡ Speed Rules — ALWAYS follow to avoid rebuilds

### RULE 1 — NEVER use `label` on shapes
The `label` property renders in Excalidraw's default sketchy handwritten font and **cannot be overridden**.
Always create a separate `text` element positioned inside the shape instead.

```json
// ❌ WRONG — label font cannot be controlled
{ "type": "rectangle", "id": "box", ..., "label": { "text": "App Service" } }

// ✅ CORRECT — explicit text element with Helvetica font
{ "type": "rectangle", "id": "box", "x": 100, "y": 100, "width": 180, "height": 80, ... },
{ "type": "text", "id": "box-t1", "x": 118, "y": 121, "text": "App Service",
  "fontFamily": 2, "fontSize": 14, "strokeColor": "#14532d", "roughness": 0 }
```

### RULE 2 — Text positioning formula
To centre text inside a box:
- Single line: `textX = boxX + 18`, `textY = boxY + (boxHeight/2) - 8`
- Two lines: line1 `textY = boxY + (boxHeight/2) - 18`, line2 `textY = boxY + (boxHeight/2) + 4`

### RULE 3 — Every element needs these properties
```json
"roughness": 0,       // removes hand-drawn look — NO EXCEPTIONS
"fontFamily": 2,      // Helvetica — on ALL text elements — NO EXCEPTIONS
"fillStyle": "solid"  // on all shapes
```

### RULE 4 — Build everything in ONE batch call
Call `excalidraw-add_elements` exactly **once** with all elements. Never call it multiple times.
Order in the array: title → subtitle → shapes → text labels → arrows → arrow labels

### RULE 5 — No rebuild loops
Do NOT rebuild the diagram if something looks off. Use `excalidraw-update_element` to fix individual elements only.

---

## Standard Component Dimensions

Use these fixed sizes for consistency — don't invent new ones:

| Component type | width | height |
|---|---|---|
| Standard service box | 185 | 85 |
| Wide service box | 220 | 85 |
| Small/supporting box | 160 | 70 |
| User ellipse | 110 | 72 |
| VNet / boundary box | fit content | fit content |

Column X positions (left-to-right flow):
- Col 1 (User/Client): x = 40
- Col 2 (Edge): x = 230
- Col 3 (Compute/Hub): x = 480
- Col 4 (Data/AI): x = 730
- Col 5 (extra): x = 980

Row Y positions:
- Title row: y = 22
- Subtitle row: y = 58
- Main flow row: y = 130
- Secondary row: y = 270
- Supporting row (security etc): y = 420

---

## Colour Palette

| Layer | Background | Stroke | Text colour |
|---|---|---|---|
| User / Client | `#dbeafe` | `#1d4ed8` | `#1e3a5f` |
| Edge (Front Door, CDN, APIM) | `#fce7f3` | `#be185d` | `#831843` |
| Compute (App Service, ACA, Functions) | `#dcfce7` | `#16a34a` | `#14532d` |
| Data (SQL, Cosmos, Storage) | `#ede9fe` | `#7c3aed` | `#4c1d95` |
| Key Vault | `#fef9c3` | `#ca8a04` | `#713f12` |
| Managed Identity | `#fee2e2` | `#dc2626` | `#7f1d1d` |
| AI (OpenAI, AI Search, Foundry) | `#e0f2fe` | `#0369a1` | `#0c4a6e` |
| Observability (Monitor, App Insights) | `#f0fdf4` | `#15803d` | `#14532d` |
| Entra ID | `#fce7f3` | `#be185d` | `#831843` |
| VNet boundary | `#f8fafc` | `#64748b` (dashed) | `#475569` |

Arrow colours:
- Primary flow: `#374151`, `strokeWidth: 2`
- Auth/identity: `#dc2626`, dashed, `strokeWidth: 2`
- Data/storage: `#7c3aed`, dashed, `strokeWidth: 1.5`
- Telemetry: `#15803d`, dashed, `strokeWidth: 1.5`

---

## Process (4 steps only)

### Step 1 — Clarify (only if not already provided)
Ask in a single message:
- Which Azure services?
- Output path for PNG? (default: `<repo-root>/architecture.png`)

### Step 2 — Plan coordinates mentally
Map each service to a column/row using the standard positions above. Do this in your head — do NOT output a planning step to the user.

### Step 3 — Build and export in 4 calls
```
1. excalidraw-create_diagram   — reset canvas
2. excalidraw-add_elements     — ALL elements in one call
3. [Font patch]                — patch fontFamily via WebSocket (see below)
4. excalidraw-export_diagram   — format: "png", path: <output>
```

### Font Patch (REQUIRED after add_elements)
The Excalidraw MCP tool ignores `fontFamily` and defaults all text to `fontFamily: 5` (Excalifont — handwritten). You MUST run this Node.js script after `add_elements` to patch all text to Helvetica (fontFamily: 2):

```
// Step 1: Export JSON
excalidraw-export_diagram  format: "json"  path: "<session-files>/diagram.json"

// Step 2: Run this PowerShell to patch + re-inject via WebSocket
$wsModule = "C:/Users/ConnelMcCann/AppData/Roaming/npm/node_modules/@scofieldfree/excalidraw-mcp/node_modules/ws"
$jsonPath = "<session-files>/diagram.json"
@"
const WebSocket = require('$wsModule');
const fs = require('fs');
const data = JSON.parse(fs.readFileSync('$jsonPath', 'utf8'));
const elements = data.elements.map(el => el.type === 'text' ? { ...el, fontFamily: 2 } : el);
const ws = new WebSocket('ws://localhost:3100');
ws.on('open', () => {
  ws.send(JSON.stringify({ type: 'update', sessionId: 'default', elements }));
  setTimeout(() => { ws.close(); process.exit(0); }, 500);
});
"@ | node
```

Do NOT navigate the browser or take screenshots unless the user specifically asks to see a preview.

### Step 4 — Confirm
One sentence: what was saved and where. Offer adjustments.

---

## Rules
- **NEVER use `label`** — always explicit `text` elements with `fontFamily: 2`
- **ALWAYS `roughness: 0`** on every element
- **ONE batch call** — never call `add_elements` more than once per diagram
- **NO rebuild loops** — fix with `update_element` if needed
- **NO browser screenshots** unless user asks for a preview
- If Excalidraw is unavailable, fall back to `create-architecture-diagram` skill (draw.io)
