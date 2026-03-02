# scaffold-demo.ps1
# Creates a new GitHub demo repo with a ready-to-use folder structure.
# Usage: .\scaffold-demo.ps1 -DemoName "my-demo" -Description "A demo of X" [-Backend fastapi|nodejs|none] [-Frontend react|none] [-GithubUser cmccann123]

param(
    [Parameter(Mandatory)][string]$DemoName,
    [Parameter(Mandatory)][string]$Description,
    [ValidateSet("fastapi","nodejs","none")][string]$Backend = "fastapi",
    [ValidateSet("react","none")][string]$Frontend = "react",
    [string]$GithubUser = "cmccann123",
    [string]$OutputDir = (Get-Location).Path
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot  # root of copilot-cli-setup
$DemoPath = Join-Path $OutputDir $DemoName

Write-Host "`n=== Scaffolding Demo: $DemoName ===" -ForegroundColor Cyan

# 1. Create GitHub repo
Write-Host "`n[1/5] Creating GitHub repository..." -ForegroundColor Yellow
gh repo create "$GithubUser/$DemoName" --public --description $Description
Write-Host "  ✓ Created: https://github.com/$GithubUser/$DemoName" -ForegroundColor Green

# 2. Clone locally
Write-Host "`n[2/5] Cloning locally..." -ForegroundColor Yellow
git clone "https://github.com/$GithubUser/$DemoName" $DemoPath
Set-Location $DemoPath
Write-Host "  ✓ Cloned to: $DemoPath" -ForegroundColor Green

# 3. Create base structure
Write-Host "`n[3/5] Creating folder structure..." -ForegroundColor Yellow

New-Item -ItemType Directory -Force -Path "infra/modules" | Out-Null
New-Item -ItemType File -Force -Path "infra/modules/.gitkeep" | Out-Null

# Copy entire .github config from copilot-cli-setup (agents, skills, instructions)
Write-Host "  Copying Copilot config from copilot-cli-setup..." -ForegroundColor Gray
$GithubSource = Join-Path $RepoRoot ".github"
$itemsToCopy = @("agents", "skills", "instructions", "copilot-instructions.md")
foreach ($item in $itemsToCopy) {
    $src = Join-Path $GithubSource $item
    if (Test-Path $src) {
        Copy-Item $src -Destination ".github\" -Recurse -Force
        Write-Host "  ✓ .github\$item copied" -ForegroundColor Green
    }
}

# 4. Generate backend
if ($Backend -eq "fastapi") {
    Write-Host "`n[4/5] Scaffolding FastAPI backend..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path "backend/routers" | Out-Null
    New-Item -ItemType Directory -Force -Path "backend/models" | Out-Null
    New-Item -ItemType Directory -Force -Path "backend/services" | Out-Null
    "fastapi`nhttpx`npydantic-settings`npython-dotenv`nstructlog`nuvicorn" | Set-Content "backend/requirements.txt"
    New-Item -ItemType File -Force -Path "backend/routers/.gitkeep" | Out-Null
    New-Item -ItemType File -Force -Path "backend/models/.gitkeep" | Out-Null
    New-Item -ItemType File -Force -Path "backend/services/.gitkeep" | Out-Null

    @'
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from config import settings

app = FastAPI(title="{DEMO_NAME}")

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
async def health():
    return {"status": "ok"}
'@.Replace("{DEMO_NAME}", $DemoName) | Set-Content "backend/main.py"

    @'
from pydantic_settings import BaseSettings
from typing import list

class Settings(BaseSettings):
    cors_origins: list[str] = ["http://localhost:5173"]

    class Config:
        env_file = ".env"

settings = Settings()
'@ | Set-Content "backend/config.py"

    @'
FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
'@ | Set-Content "backend/Dockerfile"

} elseif ($Backend -eq "nodejs") {
    Write-Host "`n[4/5] Scaffolding Node.js backend..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path "backend/src/routes" -Force | Out-Null
    New-Item -ItemType File -Force -Path "backend/src/routes/.gitkeep" | Out-Null
    '{"name":"backend","version":"1.0.0","scripts":{"dev":"tsx watch src/index.ts","start":"node dist/index.js"},"dependencies":{"express":"^4.18.0"},"devDependencies":{"typescript":"^5.0.0","tsx":"^4.0.0","@types/express":"^4.17.0"}}' | Set-Content "backend/package.json"
    @'
FROM node:20-slim
WORKDIR /app
COPY package*.json .
RUN npm ci --omit=dev
COPY . .
EXPOSE 3000
CMD ["node", "dist/index.js"]
'@ | Set-Content "backend/Dockerfile"
} else {
    Write-Host "`n[4/5] No backend selected — skipping" -ForegroundColor Gray
}

# 5. Generate frontend
if ($Frontend -eq "react") {
    Write-Host "`n[5/5] Scaffolding React frontend..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path "frontend/src/components" | Out-Null

    '{"name":"frontend","version":"0.0.0","scripts":{"dev":"vite","build":"tsc && vite build","preview":"vite preview"},"dependencies":{"react":"^18.2.0","react-dom":"^18.2.0"},"devDependencies":{"@types/react":"^18.2.0","@types/react-dom":"^18.2.0","@vitejs/plugin-react":"^4.0.0","typescript":"^5.0.0","vite":"^5.0.0","tailwindcss":"^3.4.0","autoprefixer":"^10.4.0","postcss":"^8.4.0"}}' | Set-Content "frontend/package.json"

    @'
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      '/api': { target: 'http://localhost:8000', changeOrigin: true }
    }
  }
})
'@ | Set-Content "frontend/vite.config.ts"

    '<html><head><meta charset="UTF-8"/><title>{DEMO_NAME}</title></head><body><div id="root"></div><script type="module" src="/src/main.tsx"></script></body></html>'.Replace("{DEMO_NAME}", $DemoName) | Set-Content "frontend/index.html"
    'import React from "react"; import ReactDOM from "react-dom/client"; import App from "./App"; ReactDOM.createRoot(document.getElementById("root")!).render(<React.StrictMode><App /></React.StrictMode>);' | Set-Content "frontend/src/main.tsx"
    'export default function App() { return <div className="min-h-screen bg-gray-50 flex items-center justify-center"><h1 className="text-3xl font-bold">{DEMO_NAME}</h1></div>; }'.Replace("{DEMO_NAME}", $DemoName) | Set-Content "frontend/src/App.tsx"
} else {
    Write-Host "`n[5/5] No frontend selected — skipping" -ForegroundColor Gray
}

# Generate shared files
Write-Host "`n  Generating shared files..." -ForegroundColor Gray

# .gitignore
@'
# Python
__pycache__/
*.pyc
.venv/
venv/

# Node
node_modules/
dist/
.next/

# Env
.env
*.env.local

# Azure
.azure/
*.tfstate

# OS
.DS_Store
Thumbs.db
'@ | Set-Content ".gitignore"

# .env.example
@"
# $DemoName — Environment Variables
# Copy this file to .env and fill in your values

# Azure
AZURE_TENANT_ID=
AZURE_SUBSCRIPTION_ID=

# Backend
CORS_ORIGINS=http://localhost:5173

# Add your service-specific variables below
"@ | Set-Content ".env.example"

# Bicep stubs
'// main.bicep — top-level orchestrator' + "`n" + 'targetScope = ''subscription''' | Set-Content "infra/main.bicep"
'{}' | Set-Content "infra/main.parameters.json"

# README
@"
# $DemoName

$Description

## Quick Start

### Prerequisites
- Python 3.12+ (backend)
- Node.js 20+ (frontend)
- Azure CLI + active subscription
- GitHub Copilot CLI

### 1. Clone and configure
\`\`\`bash
git clone https://github.com/$GithubUser/$DemoName
cd $DemoName
cp .env.example .env
# Fill in your values in .env
\`\`\`

### 2. Run the backend
\`\`\`bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload
\`\`\`

### 3. Run the frontend
\`\`\`bash
cd frontend
npm install
npm run dev
\`\`\`

Open http://localhost:5173

## Deploy to Azure
\`\`\`bash
azd up
\`\`\`

## Architecture
> TODO: add architecture diagram

## Environment Variables
See \`.env.example\` for all required variables.
"@ | Set-Content "README.md"

# setup scripts
"# setup.ps1`nWrite-Host 'Setting up $DemoName...'" | Set-Content "setup.ps1"
"#!/bin/bash`necho 'Setting up $DemoName...'" | Set-Content "setup.sh"

# Initial commit
Write-Host "`n  Committing initial scaffold..." -ForegroundColor Gray
git add .
git commit -m "Initial scaffold: $DemoName

Generated by scaffold-demo skill from copilot-cli-setup.

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
git push origin main

Write-Host "`n=== Done! ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "  GitHub: https://github.com/$GithubUser/$DemoName" -ForegroundColor Green
Write-Host "  Local:  $DemoPath" -ForegroundColor Green
Write-Host ""
Write-Host "Changing working directory to demo repo..." -ForegroundColor Gray
Set-Location $DemoPath
Write-Host "  ✓ Now in: $(Get-Location)" -ForegroundColor Green
Write-Host ""
Write-Host "Run 'copilot' to start building!" -ForegroundColor Cyan
