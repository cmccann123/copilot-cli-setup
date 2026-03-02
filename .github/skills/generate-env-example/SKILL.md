---
name: generate-env-example
description: Use this skill when asked to generate a .env.example file, document environment variables, or audit what env vars a project uses. Scans the codebase and produces an accurate .env.example.
---

## When to Use
Use when the user asks to:
- "generate a .env.example"
- "document env vars"
- "what environment variables does this project need"
- "create a .env template"
- "update the .env.example"

## Process

1. **Scan these files** for environment variable usage:

   **Python:**
   ```python
   os.environ.get("VAR")
   os.getenv("VAR")
   settings.VAR  # pydantic BaseSettings
   ```

   **TypeScript/Node:**
   ```typescript
   process.env.VAR
   import.meta.env.VAR
   ```

   **Shell/Docker:**
   ```
   ${VAR}
   $VAR
   ENV VAR in Dockerfile
   environment: in docker-compose.yml
   ```

2. **Group variables** by service/purpose:
```env
# ─── Azure ────────────────────────────────
AZURE_TENANT_ID=
AZURE_SUBSCRIPTION_ID=
AZURE_RESOURCE_GROUP=

# ─── Azure OpenAI ─────────────────────────
AZURE_OPENAI_ENDPOINT=
AZURE_OPENAI_API_KEY=
AZURE_OPENAI_DEPLOYMENT=gpt-4o

# ─── Database ─────────────────────────────
DATABASE_URL=postgresql://user:pass@localhost:5432/dbname

# ─── App ──────────────────────────────────
CORS_ORIGINS=http://localhost:5173
LOG_LEVEL=INFO
```

3. **Add a comment for every variable** describing what it is and where to get it

4. **Never include real values** — use descriptive placeholders:
   - `your-tenant-id` not a real GUID
   - `https://your-resource.openai.azure.com` not a real URL
   - `postgresql://user:pass@localhost:5432/dbname` for DB URLs

## Rules
- Include ALL env vars found, even ones that have defaults
- Mark required vs optional with a comment
- Sort groups logically (Azure → DB → App)
- Save as `.env.example` — never `.env`
