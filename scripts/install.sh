#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Plugin Marketplace Install Script
# ============================================================

REPO_DEFAULT=""
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Colors ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { printf "${CYAN}[INFO]${NC} %s\n" "$*"; }
ok()    { printf "${GREEN}[OK]${NC} %s\n" "$*"; }
warn()  { printf "${YELLOW}[WARN]${NC} %s\n" "$*"; }
err()   { printf "${RED}[ERROR]${NC} %s\n" "$*"; }

# --- Detect CLI tool ---
CLI=""
if command -v claude &>/dev/null; then
  CLI="claude"
  info "Detected Claude Code CLI"
elif command -v copilot &>/dev/null; then
  CLI="copilot"
  info "Detected GitHub Copilot CLI"
else
  warn "Neither claude nor copilot CLI found — skipping plugin installation."
  warn "  Claude Code: https://docs.anthropic.com/en/docs/claude-code"
  warn "  GitHub Copilot CLI: https://docs.github.com/en/copilot"
  CLI=""
fi

# --- Resolve repo path ---
REPO=""
REMOTE_URL=$(git remote get-url origin 2>/dev/null || true)
if [[ -n "$REMOTE_URL" ]]; then
  # Parse owner/repo from git remote URL
  REPO=$(echo "$REMOTE_URL" | sed -E 's#.+[:/]([^/]+/[^/.]+)(\.git)?$#\1#')
  info "Detected repo from git remote: ${REPO}"
fi

if [[ -z "$REPO" ]]; then
  if [[ -n "$REPO_DEFAULT" ]]; then
    echo -n "Enter repo (owner/repo) [${REPO_DEFAULT}]: "
  else
    echo -n "Enter repo (owner/repo): "
  fi
  read -r REPO_INPUT
  REPO="${REPO_INPUT:-$REPO_DEFAULT}"
  if [[ -z "$REPO" ]]; then
    err "No repo specified. Please provide a path in owner/repo format."
    exit 1
  fi
fi

# --- Derive marketplace name from repo path ---
# Marketplace name is the repo name (last segment of owner/repo)
MARKETPLACE_NAME="${REPO##*/}"

# Skip plugin installation if no CLI is available
if [[ -z "$CLI" ]]; then
  CHOICE="5"
else

# --- Register marketplace ---
info "Registering marketplace: ${REPO} ..."
if $CLI plugin marketplace add "$REPO" 2>/dev/null; then
  ok "Marketplace registered successfully (name: ${MARKETPLACE_NAME})"
else
  warn "Marketplace may already be registered — continuing installation..."
fi

# --- Installation menu ---
echo ""
echo "========================================="
echo "  Select plugins to install:"
echo "========================================="
echo "  [1] Install all plugins (common-tools)"
echo "  [2] Install common-tools only"
echo "  [5] Skip"
echo "  [0] Cancel"
echo "========================================="
echo -n "Enter option [1]: "
read -r CHOICE
CHOICE="${CHOICE:-1}"

fi  # end if CLI

install_plugin() {
  local plugin_name="$1"
  info "Installing ${plugin_name} ..."
  if $CLI plugin install "${plugin_name}@${MARKETPLACE_NAME}"; then
    ok "${plugin_name} installed successfully"
  else
    err "${plugin_name} installation failed"
    return 1
  fi
}

case "$CHOICE" in
  1)
    install_plugin "common-tools"
    ;;
  2)
    install_plugin "common-tools"
    ;;
  5)
    info "Skipping plugin installation"
    ;;
  0)
    info "Installation cancelled"
    exit 0
    ;;
  *)
    err "Invalid option: ${CHOICE}"
    exit 1
    ;;
esac

# --- Installation summary ---
echo ""
echo "========================================="
printf "${GREEN}  Installation complete!${NC}\n"
echo "========================================="
echo ""
echo "Available skill commands:"
echo ""

if [[ "$CHOICE" != "5" && "$CHOICE" != "0" ]]; then
  printf "  ${CYAN}common-tools${NC} (Common)\n"
  echo "    /common-tools:skill-creator          — Create, evaluate, and package skills"
  echo ""
fi

echo "Usage: type any of the above commands in Claude Code or Copilot CLI."
