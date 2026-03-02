---
name: write-readme
description: Use this skill when asked to write or improve a README, create documentation for a project, or generate a quick-start guide. Scans the codebase to produce an accurate, polished README.
---

## When to Use
Use when the user asks to:
- "write a README"
- "create documentation"
- "document this project"
- "generate a quick start guide"
- "the README is missing / outdated"

## Process

1. **Scan the project** to gather facts:
   - Entry point and how to run it
   - All environment variables (from `.env.example`, `config.py`, `appsettings.json`)
   - Dependencies and install commands (`requirements.txt`, `package.json`)
   - Any `docker-compose.yml`, `azure.yaml`, `Dockerfile`
   - Existing `README.md` (to preserve intent, fill gaps)

2. **Generate the README** using this structure:

```markdown
# <Project Name>

<One sentence: what it does and who it's for>

## Quick Start

### Prerequisites
- <tool> <version>

### 1. Clone and configure
\`\`\`bash
git clone <repo>
cd <project>
cp .env.example .env
# Edit .env with your values
\`\`\`

### 2. Install dependencies
\`\`\`bash
<install command>
\`\`\`

### 3. Run
\`\`\`bash
<run command>
\`\`\`

## Architecture
<brief description or diagram>

## Environment Variables
| Variable | Description | Required |
|---|---|---|
| VAR_NAME | What it does | Yes/No |

## Deployment
<deploy steps if applicable>

## Contributing
<optional — include if team project>
```

## Rules
- Quick Start must be completable in under 5 steps
- Every environment variable must be documented
- Don't include placeholder text — only write what's accurate for this project
- If something is unknown, ask rather than guess
