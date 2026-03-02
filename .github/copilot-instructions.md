# Copilot CLI Instructions

## Who I Am
I am a developer building demos, prototypes, and production-grade solutions — primarily for enterprise clients. My work focuses on Azure cloud services, AI/ML integrations, and modern web applications.

## Primary Tech Stack
- **Cloud:** Azure (primary), with services like Azure OpenAI, Azure AI Search, Azure Container Apps, Azure Functions, Azure Key Vault
- **Backend:** Python (FastAPI, Flask), Node.js (Express, TypeScript)
- **Frontend:** React, TypeScript, Tailwind CSS
- **Infrastructure:** Bicep, Azure Developer CLI (azd), Docker, GitHub Actions
- **AI/ML:** Azure OpenAI, LangChain, Semantic Kernel, Promptflow, Azure AI Foundry
- **Data:** PostgreSQL, Cosmos DB, Azure SQL

## Coding Standards
- Use **async/await** patterns wherever possible
- Always include **type hints** in Python and **TypeScript types** (no `any`)
- Prefer **Azure SDK** over raw REST API calls
- Follow **12-factor app** principles
- Use **environment variables** for all config — never hardcode secrets
- Write **meaningful variable and function names** — code should be self-documenting
- Add error handling and logging to all API calls and external integrations

## When Building a Demo
A "demo" should be:
- **Runnable in under 5 minutes** from a fresh clone
- Include a `README.md` with clear setup steps
- Include a `.env.example` file listing all required environment variables
- Include a `setup` script (`setup.ps1` for Windows, `setup.sh` for Linux/Mac) where helpful
- Have a clean, presentable UI if it's a web app — use Tailwind or a simple CSS framework
- Work end-to-end with minimal configuration

## When Building a Production Solution
- Generate infrastructure as code (Bicep preferred)
- Include `azure.yaml` for azd compatibility
- Include GitHub Actions CI/CD workflows
- Follow Azure Well-Architected Framework principles
- Include unit tests for core business logic

## General Preferences
- Keep responses and code changes **minimal and focused** — don't over-engineer
- When multiple approaches exist, briefly explain the tradeoff and recommend one
- Always generate a `README.md` for new projects
- Prefer **managed identity** over connection strings for Azure auth
- When in doubt, ask before making large structural changes

## Agent Delegation — ALWAYS follow this

Before responding to any request, analyse the intent and delegate to the most appropriate specialist agent from `.github/agents/`. Do not answer directly if a specialist agent exists for the task.

| If the request is about... | Delegate to |
|---|---|
| Azure infrastructure, Bicep, azd, RBAC, networking, Managed Identity | `azure-architect` |
| Building a demo, POC, or prototype for a client | `demo-builder` |
| Presales, client presentations, visual impact, storytelling | `presales` |
| Reviewing code, security issues, Azure anti-patterns, bugs | `code-reviewer` |

**Rules:**
- Always state which agent you are delegating to and why, before responding
- If a request spans multiple agents (e.g. "build a demo AND review the infra"), run them sequentially — demo-builder first, then azure-architect
- Only answer directly yourself if no specialist agent covers the request (e.g. general coding questions, explaining concepts, session management)
- If the request is ambiguous, pick the closest agent and note the assumption
