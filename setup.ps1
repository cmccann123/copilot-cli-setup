# setup.ps1 — Copilot CLI Setup Script (Windows)
# Run this once to configure Copilot CLI with shared settings and secrets from Azure Key Vault.
# Usage: .\setup.ps1 [-KeyVaultName <name>] [-SkipKeyVault]

param(
    [string]$KeyVaultName = "",
    [switch]$SkipKeyVault
)

$ErrorActionPreference = "Stop"
$RepoRoot = $PSScriptRoot
$CopilotConfigDir = "$env:USERPROFILE\.copilot"

Write-Host "`n=== Copilot CLI Setup ===" -ForegroundColor Cyan

# 1. Check prerequisites
Write-Host "`n[1/5] Checking prerequisites..." -ForegroundColor Yellow

if ($PSVersionTable.PSVersion.Major -lt 6) {
    Write-Error "PowerShell 6+ is required. Current version: $($PSVersionTable.PSVersion). Install from: https://aka.ms/powershell"
}
Write-Host "  ✓ PowerShell $($PSVersionTable.PSVersion)" -ForegroundColor Green

try { $null = Get-Command copilot -ErrorAction Stop; Write-Host "  ✓ Copilot CLI installed" -ForegroundColor Green }
catch { Write-Warning "  ! Copilot CLI not found. Install with: winget install GitHub.Copilot" }

try { $null = Get-Command az -ErrorAction Stop; Write-Host "  ✓ Azure CLI installed" -ForegroundColor Green }
catch { Write-Warning "  ! Azure CLI not found. Install from: https://aka.ms/installazurecliwindows" }

try { $null = Get-Command node -ErrorAction Stop; Write-Host "  ✓ Node.js installed" -ForegroundColor Green }
catch { Write-Warning "  ! Node.js not found. Some MCP servers require Node.js." }

try { $null = Get-Command deno -ErrorAction Stop; Write-Host "  ✓ Deno installed" -ForegroundColor Green }
catch { Write-Warning "  ! Deno not found. Required for draw.io MCP server. Install from: https://deno.com" }

# 2. Create Copilot config directory
Write-Host "`n[2/5] Setting up config directory..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $CopilotConfigDir | Out-Null
Write-Host "  ✓ Config directory: $CopilotConfigDir" -ForegroundColor Green

# 3. Copy MCP config template
Write-Host "`n[3/5] Configuring MCP servers..." -ForegroundColor Yellow
$mcpTemplate = Join-Path $RepoRoot "mcp\mcp-config.template.json"
$mcpTarget = Join-Path $CopilotConfigDir "mcp-config.json"

if (Test-Path $mcpTarget) {
    Write-Warning "  ! mcp-config.json already exists. Skipping to avoid overwrite. Delete it manually to reset."
} else {
    Copy-Item $mcpTemplate $mcpTarget
    Write-Host "  ✓ MCP config copied to $mcpTarget" -ForegroundColor Green
    Write-Host "    Edit this file to fill in your credentials, or use Key Vault (see step 4)." -ForegroundColor Gray
}

# 4. Pull secrets from Azure Key Vault (optional)
Write-Host "`n[4/5] Fetching secrets from Azure Key Vault..." -ForegroundColor Yellow

if ($SkipKeyVault) {
    Write-Host "  Skipped (--SkipKeyVault flag set)" -ForegroundColor Gray
} elseif ($KeyVaultName -eq "") {
    Write-Host "  Skipped (no Key Vault name provided)" -ForegroundColor Gray
    Write-Host "  Re-run with: .\setup.ps1 -KeyVaultName <your-vault-name>" -ForegroundColor Gray
} else {
    try {
        Write-Host "  Pulling secrets from: $KeyVaultName" -ForegroundColor Gray

        $azureTenantId     = az keyvault secret show --vault-name $KeyVaultName --name "azure-tenant-id"     --query "value" -o tsv 2>$null
        $azureClientId     = az keyvault secret show --vault-name $KeyVaultName --name "azure-client-id"     --query "value" -o tsv 2>$null
        $azureClientSecret = az keyvault secret show --vault-name $KeyVaultName --name "azure-client-secret" --query "value" -o tsv 2>$null

        # Substitute placeholders in MCP config
        $mcpConfig = Get-Content $mcpTarget -Raw
        if ($azureTenantId)     { $mcpConfig = $mcpConfig -replace '\$\{AZURE_TENANT_ID\}',     $azureTenantId }
        if ($azureClientId)     { $mcpConfig = $mcpConfig -replace '\$\{AZURE_CLIENT_ID\}',     $azureClientId }
        if ($azureClientSecret) { $mcpConfig = $mcpConfig -replace '\$\{AZURE_CLIENT_SECRET\}', $azureClientSecret }
        Set-Content $mcpTarget $mcpConfig

        Write-Host "  ✓ Secrets injected into MCP config" -ForegroundColor Green
    } catch {
        Write-Warning "  ! Could not fetch secrets from Key Vault. Are you logged in? Run: az login"
    }
}

# 5. Copy agents and skills globally
Write-Host "`n[5/7] Copying agents and skills to global config..." -ForegroundColor Yellow

# Agents → ~/.copilot/agents/ (user-level, available globally)
$agentsSource = Join-Path $RepoRoot ".github\agents"
$agentsTarget = Join-Path $CopilotConfigDir "agents"
if (Test-Path $agentsSource) {
    Copy-Item -Path $agentsSource -Destination $CopilotConfigDir -Recurse -Force
    Write-Host "  ✓ Agents copied to $agentsTarget" -ForegroundColor Green
}

# Skills → ~/.copilot/skills/ (user-level, available globally)
$skillsSource = Join-Path $RepoRoot ".github\skills"
$skillsTarget = Join-Path $CopilotConfigDir "skills"
if (Test-Path $skillsSource) {
    Copy-Item -Path $skillsSource -Destination $CopilotConfigDir -Recurse -Force
    Write-Host "  ✓ Skills copied to $skillsTarget" -ForegroundColor Green
}

# Instructions → ~/.copilot/copilot-instructions.md (global)
$globalInstructions = Join-Path $RepoRoot ".github\copilot-instructions.md"
$globalInstructionsTarget = Join-Path $CopilotConfigDir "copilot-instructions.md"
if (Test-Path $globalInstructions) {
    Copy-Item -Path $globalInstructions -Destination $globalInstructionsTarget -Force
    Write-Host "  ✓ copilot-instructions.md copied to $globalInstructionsTarget" -ForegroundColor Green
}

# 6. Install MCP server dependencies
Write-Host "`n[6/7] Installing MCP server dependencies..." -ForegroundColor Yellow

$nodePackages = @("@playwright/mcp", "@azure/mcp")
foreach ($pkg in $nodePackages) {
    try {
        Write-Host "  Installing $pkg..." -ForegroundColor Gray
        npm install -g $pkg --quiet 2>$null
        Write-Host "  ✓ $pkg" -ForegroundColor Green
    } catch {
        Write-Warning "  ! Failed to install $pkg. Install manually: npm install -g $pkg"
    }
}

# 7. Set up draw.io MCP server
Write-Host "`n[7/7] Setting up draw.io MCP server..." -ForegroundColor Yellow
$drawioDir = "$env:USERPROFILE\drawio-mcp-server"

if (Test-Path $drawioDir) {
    Write-Host "  ✓ draw.io MCP server already cloned at $drawioDir" -ForegroundColor Green
} elseif (Get-Command deno -ErrorAction SilentlyContinue) {
    try {
        Write-Host "  Cloning simonkurtz-MSFT/drawio-mcp-server..." -ForegroundColor Gray
        git clone https://github.com/simonkurtz-MSFT/drawio-mcp-server $drawioDir --quiet
        Write-Host "  ✓ Cloned to $drawioDir" -ForegroundColor Green

        # Update DRAWIO_MCP_PATH in mcp-config.json
        $mcpConfig = Get-Content $mcpTarget -Raw
        $mcpConfig = $mcpConfig -replace '\$\{DRAWIO_MCP_PATH\}', ($drawioDir -replace '\\', '/')
        Set-Content $mcpTarget $mcpConfig
        Write-Host "  ✓ DRAWIO_MCP_PATH set in mcp-config.json" -ForegroundColor Green
    } catch {
        Write-Warning "  ! Failed to clone draw.io MCP server. Clone manually: git clone https://github.com/simonkurtz-MSFT/drawio-mcp-server $drawioDir"
    }
} else {
    Write-Warning "  ! Deno not installed — skipping draw.io MCP server setup. Install Deno from https://deno.com then re-run this script."
}

# Done
Write-Host "`n=== Setup Complete! ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. cd into a project folder"
Write-Host "  2. Run: copilot"
Write-Host "  3. Use /agent to select a specialist agent"
Write-Host "  4. Use /mcp show to verify MCP servers are connected"
Write-Host ""
Write-Host "Run .\scripts\verify-setup.ps1 to check your configuration." -ForegroundColor Gray
Write-Host ""
Write-Host "To open a diagram: code <file>.drawio (requires VS Code Draw.io extension: hediet.vscode-drawio)" -ForegroundColor Gray
