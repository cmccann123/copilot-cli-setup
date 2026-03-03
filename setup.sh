#!/bin/bash
# setup.sh — Copilot CLI Setup Script (macOS/Linux)
# Run once to configure Copilot CLI with shared settings and secrets from Azure Key Vault.
# Usage: ./setup.sh [--key-vault-name <name>] [--skip-key-vault]

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COPILOT_CONFIG_DIR="$HOME/.copilot"
KEY_VAULT_NAME=""
SKIP_KEY_VAULT=false

# Parse args
while [[ $# -gt 0 ]]; do
  case $1 in
    --key-vault-name) KEY_VAULT_NAME="$2"; shift 2 ;;
    --skip-key-vault) SKIP_KEY_VAULT=true; shift ;;
    *) shift ;;
  esac
done

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; GRAY='\033[0;37m'; RESET='\033[0m'

echo -e "\n${CYAN}=== Copilot CLI Setup ===${RESET}"

# 1. Check prerequisites
echo -e "\n${YELLOW}[1/5] Checking prerequisites...${RESET}"

command -v copilot &>/dev/null && echo -e "  ${GREEN}✓ Copilot CLI installed${RESET}" || echo "  ! Copilot CLI not found. Install from: https://github.com/github/copilot-cli"
command -v az &>/dev/null && echo -e "  ${GREEN}✓ Azure CLI installed${RESET}" || echo "  ! Azure CLI not found. Install from: https://docs.microsoft.com/cli/azure/install-azure-cli"
command -v node &>/dev/null && echo -e "  ${GREEN}✓ Node.js installed${RESET}" || echo "  ! Node.js not found. Some MCP servers require Node.js."

# 2. Create config directory
echo -e "\n${YELLOW}[2/5] Setting up config directory...${RESET}"
mkdir -p "$COPILOT_CONFIG_DIR"
echo -e "  ${GREEN}✓ Config directory: $COPILOT_CONFIG_DIR${RESET}"

# 3. Copy MCP config template
echo -e "\n${YELLOW}[3/5] Configuring MCP servers...${RESET}"
MCP_TEMPLATE="$REPO_ROOT/mcp/mcp-config.template.json"
MCP_TARGET="$COPILOT_CONFIG_DIR/mcp-config.json"

if [ -f "$MCP_TARGET" ]; then
  echo "  ! mcp-config.json already exists. Skipping. Delete it manually to reset."
else
  cp "$MCP_TEMPLATE" "$MCP_TARGET"
  echo -e "  ${GREEN}✓ MCP config copied to $MCP_TARGET${RESET}"
fi

# 4. Pull secrets from Azure Key Vault
echo -e "\n${YELLOW}[4/5] Fetching secrets from Azure Key Vault...${RESET}"

if [ "$SKIP_KEY_VAULT" = true ]; then
  echo -e "  ${GRAY}Skipped (--skip-key-vault flag set)${RESET}"
elif [ -z "$KEY_VAULT_NAME" ]; then
  echo -e "  ${GRAY}Skipped. Re-run with: ./setup.sh --key-vault-name <your-vault-name>${RESET}"
else
  AZURE_TENANT_ID=$(az keyvault secret show --vault-name "$KEY_VAULT_NAME" --name "azure-tenant-id" --query "value" -o tsv 2>/dev/null || true)
  AZURE_CLIENT_ID=$(az keyvault secret show --vault-name "$KEY_VAULT_NAME" --name "azure-client-id" --query "value" -o tsv 2>/dev/null || true)
  AZURE_CLIENT_SECRET=$(az keyvault secret show --vault-name "$KEY_VAULT_NAME" --name "azure-client-secret" --query "value" -o tsv 2>/dev/null || true)

  [ -n "$AZURE_TENANT_ID" ]     && sed -i "s|\${AZURE_TENANT_ID}|$AZURE_TENANT_ID|g" "$MCP_TARGET"
  [ -n "$AZURE_CLIENT_ID" ]     && sed -i "s|\${AZURE_CLIENT_ID}|$AZURE_CLIENT_ID|g" "$MCP_TARGET"
  [ -n "$AZURE_CLIENT_SECRET" ] && sed -i "s|\${AZURE_CLIENT_SECRET}|$AZURE_CLIENT_SECRET|g" "$MCP_TARGET"
  echo -e "  ${GREEN}✓ Secrets injected into MCP config${RESET}"
fi

# 5. Copy agents and skills globally
echo -e "\n${YELLOW}[5/6] Copying agents and skills to global config...${RESET}"

# Agents → ~/.copilot/agents/ (user-level, available globally)
if [ -d "$REPO_ROOT/.github/agents" ]; then
  cp -r "$REPO_ROOT/.github/agents" "$COPILOT_CONFIG_DIR/"
  echo -e "  ${GREEN}✓ Agents copied to $COPILOT_CONFIG_DIR/agents${RESET}"
fi

# Skills → ~/.copilot/skills/ (user-level, available globally)
if [ -d "$REPO_ROOT/.github/skills" ]; then
  cp -r "$REPO_ROOT/.github/skills" "$COPILOT_CONFIG_DIR/"
  echo -e "  ${GREEN}✓ Skills copied to $COPILOT_CONFIG_DIR/skills${RESET}"
fi

# Instructions → ~/.copilot/copilot-instructions.md (global)
if [ -f "$REPO_ROOT/.github/copilot-instructions.md" ]; then
  cp "$REPO_ROOT/.github/copilot-instructions.md" "$COPILOT_CONFIG_DIR/copilot-instructions.md"
  echo -e "  ${GREEN}✓ copilot-instructions.md copied to $COPILOT_CONFIG_DIR${RESET}"
fi

# 6. Install MCP dependencies
echo -e "\n${YELLOW}[6/6] Installing MCP server dependencies...${RESET}"
for pkg in "@playwright/mcp" "@azure/mcp"; do
  npm install -g "$pkg" --quiet 2>/dev/null && echo -e "  ${GREEN}✓ $pkg${RESET}" || echo "  ! Failed to install $pkg. Run: npm install -g $pkg"
done

echo -e "\n${CYAN}=== Setup Complete! ===${RESET}"
echo ""
echo "Next steps:"
echo "  1. cd into a project folder"
echo "  2. Run: copilot"
echo "  3. Use /agent to select a specialist agent"
echo "  4. Use /mcp show to verify MCP servers are connected"
