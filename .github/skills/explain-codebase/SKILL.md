---
name: explain-codebase
description: Use this skill when asked to explain, summarise, or understand an unfamiliar codebase, repository, or project structure. Produces a structured overview of architecture, entry points, and key files.
---

## When to Use
Use when the user asks:
- "explain this codebase"
- "what does this repo do"
- "walk me through this project"
- "I just cloned this, where do I start"
- "summarise the architecture"

## Process

1. **Read the root directory** — identify project type from files present:
   - `package.json` → Node.js/TypeScript
   - `requirements.txt` / `pyproject.toml` → Python
   - `*.bicep` / `azure.yaml` → Azure IaC
   - `docker-compose.yml` → containerised app
   - `*.sln` / `*.csproj` → .NET

2. **Read these files first** (in order):
   - `README.md` — stated purpose and setup
   - Entry point (`main.py`, `index.ts`, `Program.cs`, `app.py`)
   - Config file (`config.py`, `.env.example`, `appsettings.json`)
   - Any `azure.yaml` or `docker-compose.yml`

3. **Produce a structured summary:**

```
## What This Project Does
<one paragraph>

## Tech Stack
- Language/Framework:
- Database:
- Infrastructure:
- Key dependencies:

## Entry Points
- <file>: <what it does>

## Folder Structure
- <folder>/: <purpose>

## How to Run It
<steps from README or inferred>

## Key Things to Know
<gotchas, non-obvious design decisions, important patterns>
```

## Rules
- Be concise — this is an orientation, not documentation
- Flag anything unusual or non-standard
- If README is missing or outdated, say so
