---
name: scaffold-demo
description: Use this skill whenever the user asks to create a new demo, start a new project, scaffold a project, or build a new prototype. Runs scaffold-demo.ps1 to create a GitHub repo with a ready-to-use demo folder structure.
---

## When to Use This Skill

Use this skill when the user says anything like:
- "create a new demo"
- "scaffold a project"
- "start a new demo repo"
- "set up a new project"
- "build a [thing] demo"

## What This Skill Does

Runs `scaffold-demo.ps1` to:
1. Create a new GitHub repository under `cmccann123`
2. Clone it locally into the current working directory
3. Generate a full demo-ready folder structure
4. Create placeholder files (README, .env.example, Dockerfile, etc.)
5. Make an initial commit and push to GitHub

## How to Use It

Before running the script, ask the user for:
- **Demo name** (required) — becomes the repo name, e.g. `jetstar-ai-support-demo`
- **Demo description** (required) — one sentence, used in the repo description and README
- **Backend type** — `fastapi` (default), `nodejs`, or `none`
- **Frontend type** — `react` (default), `none`

Then run:
```
.\scaffold-demo.ps1 -DemoName "<name>" -Description "<description>" -Backend fastapi -Frontend react
```

Or with no frontend (API-only demo):
```
.\scaffold-demo.ps1 -DemoName "<name>" -Description "<description>" -Backend fastapi -Frontend none
```

## Folder Structure Created

```
<demo-name>/
├── README.md                  ← pre-filled with demo name, description, quick start
├── .env.example               ← placeholder env vars
├── .gitignore                 ← Python + Node + Azure
├── setup.ps1                  ← Windows setup script (placeholder)
├── setup.sh                   ← Mac/Linux setup script (placeholder)
├── backend/                   ← if backend=fastapi
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── main.py
│   ├── routers/
│   │   └── .gitkeep
│   ├── models/
│   │   └── .gitkeep
│   ├── services/
│   │   └── .gitkeep
│   └── config.py
├── frontend/                  ← if frontend=react
│   ├── package.json
│   ├── index.html
│   ├── vite.config.ts
│   └── src/
│       ├── main.tsx
│       ├── App.tsx
│       └── components/
│           └── .gitkeep
├── infra/                     ← Azure IaC (always included)
│   ├── main.bicep
│   ├── main.parameters.json
│   └── modules/
│       └── .gitkeep
└── .github/
    ├── copilot-instructions.md  ← copied from copilot-cli-setup
    ├── agents/                  ← copied from copilot-cli-setup
    ├── skills/                  ← copied from copilot-cli-setup
    └── instructions/            ← copied from copilot-cli-setup
```

## After Scaffolding

Tell the user:
1. The GitHub repo URL
2. The local folder path
3. Run `/cwd C:\Users\ConnelMcCann\Repos\<demo-name>` to switch the Copilot session into the new repo
4. Suggested next prompt: "Now build the [feature] for this demo"

> **Important:** The script must be dot-sourced to change the terminal directory:
> `. .\scaffold-demo.ps1 -DemoName "..." -Description "..."`
> Without the leading `.`, the directory change only applies inside the script process.
