# verify-setup.ps1 — Checks that Copilot CLI is correctly configured
# Run after setup.ps1 to confirm everything is in order.

$CopilotConfigDir = "$env:USERPROFILE\.copilot"
$pass = 0; $warn = 0; $fail = 0

function Check($label, $ok, $message, $fix = "") {
    if ($ok) { Write-Host "  ✓ $label" -ForegroundColor Green; $script:pass++ }
    else {
        if ($fix) { Write-Warning "  ! $label — $message`n    Fix: $fix"; $script:warn++ }
        else { Write-Host "  ✗ $label — $message" -ForegroundColor Red; $script:fail++ }
    }
}

Write-Host "`n=== Copilot CLI Verification ===" -ForegroundColor Cyan

Write-Host "`n[Prerequisites]" -ForegroundColor Yellow
Check "PowerShell 6+"      ($PSVersionTable.PSVersion.Major -ge 6) "Version $($PSVersionTable.PSVersion) found" "Install from https://aka.ms/powershell"
Check "Copilot CLI"        ($null -ne (Get-Command copilot -ErrorAction SilentlyContinue)) "Not found" "winget install GitHub.Copilot"
Check "Azure CLI"          ($null -ne (Get-Command az -ErrorAction SilentlyContinue)) "Not found" "winget install Microsoft.AzureCLI"
Check "Node.js"            ($null -ne (Get-Command node -ErrorAction SilentlyContinue)) "Not found (needed for MCP servers)" "https://nodejs.org"
Check "Git"                ($null -ne (Get-Command git -ErrorAction SilentlyContinue)) "Not found" "winget install Git.Git"

Write-Host "`n[Copilot Config]" -ForegroundColor Yellow
Check "Config directory"   (Test-Path $CopilotConfigDir) "$CopilotConfigDir not found" "Run .\setup.ps1"
Check "MCP config exists"  (Test-Path "$CopilotConfigDir\mcp-config.json") "mcp-config.json not found" "Run .\setup.ps1"

if (Test-Path "$CopilotConfigDir\mcp-config.json") {
    $mcpContent = Get-Content "$CopilotConfigDir\mcp-config.json" -Raw
    $hasPlaceholders = $mcpContent -match '\$\{[A-Z_]+\}'
    Check "MCP secrets filled" (-not $hasPlaceholders) "Placeholders still present in mcp-config.json" "Run .\setup.ps1 -KeyVaultName <vault> or edit manually"
}

Write-Host "`n[MCP Server Packages]" -ForegroundColor Yellow
$mcpPackages = @("@playwright/mcp", "@azure/mcp")
foreach ($pkg in $mcpPackages) {
    $installed = npm list -g $pkg --depth=0 2>$null | Select-String $pkg
    Check "$pkg" ($null -ne $installed) "Not installed" "npm install -g $pkg"
}

Write-Host "`n[Azure Auth]" -ForegroundColor Yellow
try {
    $account = az account show 2>$null | ConvertFrom-Json
    Check "Azure CLI logged in" ($null -ne $account) "Not authenticated" "az login"
    if ($account) { Write-Host "    Subscription: $($account.name)" -ForegroundColor Gray }
} catch {
    Check "Azure CLI logged in" $false "Not authenticated" "az login"
}

# Summary
Write-Host "`n--- Summary ---" -ForegroundColor Cyan
Write-Host "  Passed:   $pass" -ForegroundColor Green
if ($warn -gt 0) { Write-Host "  Warnings: $warn" -ForegroundColor Yellow }
if ($fail -gt 0) { Write-Host "  Failed:   $fail" -ForegroundColor Red }

if ($fail -eq 0 -and $warn -eq 0) {
    Write-Host "`n✓ All checks passed — you're ready to use Copilot CLI!" -ForegroundColor Green
} elseif ($fail -eq 0) {
    Write-Host "`n⚠ Setup mostly complete — review warnings above." -ForegroundColor Yellow
} else {
    Write-Host "`n✗ Some checks failed — run .\setup.ps1 to fix them." -ForegroundColor Red
}
