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
- "explain this codebase https://github.com/owner/repo" (GitHub URL provided)

## Source Detection

**If a GitHub URL is provided** (e.g. `https://github.com/owner/repo`):
- Extract `owner` and `repo` from the URL
- Use the GitHub MCP server to fetch the repo contents:
  1. `get_file_contents` on `/` to list root files and directories
  2. `get_file_contents` on `README.md`
  3. `get_file_contents` on key entry point files (`agent/`, `src/`, `app/`, `main.py`, etc.)
  4. `get_file_contents` on `package.json` or `pyproject.toml` for dependencies
- Proceed to the structured summary below

**If no URL is provided** (local repo):
- Use `glob`/`view`/`grep` tools on the current working directory

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
