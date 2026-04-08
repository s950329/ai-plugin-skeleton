#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# create-plugin.sh — Scaffold a new plugin and register it
#
# Interactive mode (default):
#   bash scripts/create-plugin.sh
#
# Non-interactive mode (for agent use):
#   bash scripts/create-plugin.sh \
#     --name my-plugin \
#     --description "Does something useful" \
#     --category productivity \
#     --tags "ai,automation" \
#     --skill-name my-skill \
#     --skill-description "Skill description here"
#
#   To skip creating a first skill:
#     --no-first-skill
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
TEMPLATES_DIR="${ROOT_DIR}/.skeleton/templates/plugin"
MARKETPLACE_JSON="${ROOT_DIR}/marketplace.json"

# --- Colors ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

info()  { printf "${CYAN}[INFO]${NC} %s\n" "$*"; }
ok()    { printf "${GREEN}[OK]${NC} %s\n" "$*"; }
warn()  { printf "${YELLOW}[WARN]${NC} %s\n" "$*"; }
err()   { printf "${RED}[ERROR]${NC} %s\n" "$*" >&2; }
header(){ printf "\n${BOLD}%s${NC}\n" "$*"; }

# --- Validation helpers ---
is_kebab_case() {
  [[ "$1" =~ ^[a-z][a-z0-9-]*[a-z0-9]$|^[a-z]$ ]]
}

prompt_required() {
  local label="$1" var_name="$2" default="${3:-}"
  local value=""
  while [[ -z "$value" ]]; do
    if [[ -n "$default" ]]; then
      printf "%s [${default}]: " "$label"
    else
      printf "%s: " "$label"
    fi
    read -r value
    value="${value:-$default}"
    if [[ -z "$value" ]]; then
      warn "This field is required."
    fi
  done
  printf -v "$var_name" '%s' "$value"
}

# --- Parse CLI flags (non-interactive mode) ---
NON_INTERACTIVE=false
ARG_NAME=""
ARG_DESCRIPTION=""
ARG_CATEGORY=""
ARG_TAGS=""
ARG_SKILL_NAME=""
ARG_SKILL_DESCRIPTION=""
ARG_NO_FIRST_SKILL=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --name)            ARG_NAME="$2";             shift 2 ;;
    --description)     ARG_DESCRIPTION="$2";      shift 2 ;;
    --category)        ARG_CATEGORY="$2";         shift 2 ;;
    --tags)            ARG_TAGS="$2";             shift 2 ;;
    --skill-name)      ARG_SKILL_NAME="$2";       shift 2 ;;
    --skill-description) ARG_SKILL_DESCRIPTION="$2"; shift 2 ;;
    --no-first-skill)  ARG_NO_FIRST_SKILL=true;   shift ;;
    *)
      err "Unknown option: $1"
      echo "Usage: $0 [--name NAME] [--description DESC] [--category CAT] [--tags TAGS] [--skill-name NAME] [--skill-description DESC] [--no-first-skill]"
      exit 1
      ;;
  esac
done

# If any flag was provided, use non-interactive mode
if [[ -n "$ARG_NAME" || -n "$ARG_DESCRIPTION" || "$ARG_NO_FIRST_SKILL" == true ]]; then
  NON_INTERACTIVE=true
fi

# ============================================================
# Collect plugin info
# ============================================================

if [[ "$NON_INTERACTIVE" == true ]]; then
  # --- Non-interactive: validate required flags ---
  if [[ -z "$ARG_NAME" ]]; then
    err "--name is required in non-interactive mode"
    exit 1
  fi
  if [[ -z "$ARG_DESCRIPTION" ]]; then
    err "--description is required in non-interactive mode"
    exit 1
  fi
  if ! is_kebab_case "$ARG_NAME"; then
    err "Plugin name must be kebab-case (lowercase letters, numbers, hyphens). Got: ${ARG_NAME}"
    exit 1
  fi

  PLUGIN_NAME="$ARG_NAME"
  PLUGIN_DESCRIPTION="$ARG_DESCRIPTION"
  PLUGIN_CATEGORY="${ARG_CATEGORY:-productivity}"
  TAGS_INPUT="$ARG_TAGS"

  PLUGIN_DIR="${ROOT_DIR}/plugins/${PLUGIN_NAME}"
  if [[ -d "$PLUGIN_DIR" ]]; then
    err "Plugin '${PLUGIN_NAME}' already exists at ${PLUGIN_DIR}"
    exit 1
  fi

  if [[ "$ARG_NO_FIRST_SKILL" == true ]]; then
    SKILL_NAME=""
    SKILL_DESCRIPTION=""
  else
    SKILL_NAME="$ARG_SKILL_NAME"
    SKILL_DESCRIPTION="$ARG_SKILL_DESCRIPTION"
    if [[ -n "$SKILL_NAME" ]] && ! is_kebab_case "$SKILL_NAME"; then
      err "Skill name must be kebab-case. Got: ${SKILL_NAME}"
      exit 1
    fi
  fi

else
  # --- Interactive mode ---
  header "=== Create New Plugin ==="
  echo ""

  # Plugin name
  PLUGIN_NAME=""
  while true; do
    prompt_required "Plugin name (kebab-case)" PLUGIN_NAME
    if ! is_kebab_case "$PLUGIN_NAME"; then
      warn "Name must be kebab-case (lowercase letters, numbers, hyphens). E.g. my-plugin"
      PLUGIN_NAME=""
      continue
    fi
    PLUGIN_DIR="${ROOT_DIR}/plugins/${PLUGIN_NAME}"
    if [[ -d "$PLUGIN_DIR" ]]; then
      err "Plugin '${PLUGIN_NAME}' already exists at ${PLUGIN_DIR}"
      PLUGIN_NAME=""
      continue
    fi
    break
  done

  # Plugin description
  prompt_required "Plugin description" PLUGIN_DESCRIPTION

  # Category
  printf "Category [productivity]: "
  read -r PLUGIN_CATEGORY
  PLUGIN_CATEGORY="${PLUGIN_CATEGORY:-productivity}"

  # Tags
  printf "Tags (comma-separated, optional): "
  read -r TAGS_INPUT

  # First skill?
  echo ""
  printf "Create a first skill? [Y/n]: "
  read -r CREATE_SKILL
  CREATE_SKILL="${CREATE_SKILL:-Y}"

  SKILL_NAME=""
  SKILL_DESCRIPTION=""
  if [[ "$CREATE_SKILL" =~ ^[Yy] ]]; then
    echo ""
    while true; do
      prompt_required "Skill name (kebab-case)" SKILL_NAME
      if ! is_kebab_case "$SKILL_NAME"; then
        warn "Name must be kebab-case. E.g. my-skill"
        SKILL_NAME=""
      else
        break
      fi
    done
    prompt_required "Skill description" SKILL_DESCRIPTION
  fi

  PLUGIN_DIR="${ROOT_DIR}/plugins/${PLUGIN_NAME}"

  # --- Confirm ---
  echo ""
  header "--- Summary ---"
  echo "  Plugin name   : ${PLUGIN_NAME}"
  echo "  Description   : ${PLUGIN_DESCRIPTION}"
  echo "  Category      : ${PLUGIN_CATEGORY}"
  echo "  Tags          : ${TAGS_INPUT:-（none）}"
  if [[ -n "$SKILL_NAME" ]]; then
    echo "  First skill   : ${SKILL_NAME}"
  fi
  echo ""
  printf "Proceed? [Y/n]: "
  read -r CONFIRM
  CONFIRM="${CONFIRM:-Y}"
  if [[ ! "$CONFIRM" =~ ^[Yy] ]]; then
    info "Aborted."
    exit 0
  fi
fi

# ============================================================
# Build JSON tags array
# ============================================================
TAGS_JSON="[]"
if [[ -n "${TAGS_INPUT:-}" ]]; then
  TAGS_JSON="["
  IFS=',' read -ra TAG_ARRAY <<< "$TAGS_INPUT"
  first=true
  for tag in "${TAG_ARRAY[@]}"; do
    tag="$(echo "$tag" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    if [[ -n "$tag" ]]; then
      if [[ "$first" == true ]]; then
        TAGS_JSON+="\"${tag}\""
        first=false
      else
        TAGS_JSON+=", \"${tag}\""
      fi
    fi
  done
  TAGS_JSON+="]"
fi

# ============================================================
# Create plugin structure
# ============================================================
echo ""
info "Creating plugin structure..."

mkdir -p "${PLUGIN_DIR}/.claude-plugin"
mkdir -p "${PLUGIN_DIR}/.github/plugin"
mkdir -p "${PLUGIN_DIR}/skills"

# --- Generate plugin.json from template ---
sed \
  -e "s|{{PLUGIN_NAME}}|${PLUGIN_NAME}|g" \
  -e "s|{{PLUGIN_DESCRIPTION}}|${PLUGIN_DESCRIPTION}|g" \
  "${TEMPLATES_DIR}/plugin.json.tpl" > "${PLUGIN_DIR}/plugin.json"

ok "Created ${PLUGIN_DIR}/plugin.json"

# --- Create symlinks ---
ln -s "../plugin.json" "${PLUGIN_DIR}/.claude-plugin/plugin.json"
ok "Created symlink .claude-plugin/plugin.json -> ../plugin.json"

ln -s "../../plugin.json" "${PLUGIN_DIR}/.github/plugin/plugin.json"
ok "Created symlink .github/plugin/plugin.json -> ../../plugin.json"

# --- Create first skill (if provided) ---
if [[ -n "$SKILL_NAME" ]]; then
  SKILL_DIR="${PLUGIN_DIR}/skills/${SKILL_NAME}"
  mkdir -p "${SKILL_DIR}"

  sed \
    -e "s|{{SKILL_NAME}}|${SKILL_NAME}|g" \
    -e "s|{{SKILL_DESCRIPTION}}|${SKILL_DESCRIPTION}|g" \
    "${TEMPLATES_DIR}/SKILL.md.tpl" > "${SKILL_DIR}/SKILL.md"

  ok "Created ${SKILL_DIR}/SKILL.md"
fi

# ============================================================
# Register in marketplace.json
# ============================================================
info "Registering plugin in marketplace.json..."

NEW_ENTRY="{
      \"name\": \"${PLUGIN_NAME}\",
      \"description\": \"${PLUGIN_DESCRIPTION}\",
      \"version\": \"1.0.0\",
      \"source\": \"./plugins/${PLUGIN_NAME}\",
      \"category\": \"${PLUGIN_CATEGORY}\",
      \"tags\": ${TAGS_JSON}
    }"

if command -v jq &>/dev/null; then
  TMP_FILE="$(mktemp)"
  jq --argjson entry "$NEW_ENTRY" '.plugins += [$entry]' "${MARKETPLACE_JSON}" > "$TMP_FILE"
  mv "$TMP_FILE" "${MARKETPLACE_JSON}"
elif command -v python3 &>/dev/null; then
  python3 - <<PYEOF
import json

with open('${MARKETPLACE_JSON}', 'r') as f:
    data = json.load(f)

entry = json.loads('''${NEW_ENTRY}''')
data['plugins'].append(entry)

with open('${MARKETPLACE_JSON}', 'w') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write('\n')
PYEOF
else
  warn "Neither jq nor python3 found. Add this entry to marketplace.json manually:"
  echo ""
  echo "$NEW_ENTRY"
  echo ""
fi

ok "Registered '${PLUGIN_NAME}' in marketplace.json"

# ============================================================
# Done
# ============================================================
echo ""
header "=== Plugin created successfully! ==="
echo ""
echo "  Location : plugins/${PLUGIN_NAME}/"
if [[ -n "$SKILL_NAME" ]]; then
  echo "  Skill    : plugins/${PLUGIN_NAME}/skills/${SKILL_NAME}/SKILL.md"
  echo "  Command  : /${PLUGIN_NAME}:${SKILL_NAME}"
fi
echo ""
echo "Next steps:"
echo "  1. Edit plugins/${PLUGIN_NAME}/skills/*/SKILL.md to define your skill"
echo "  2. Bump version in plugins/${PLUGIN_NAME}/plugin.json when content changes"
echo "  3. Update README.md and AGENTS.md to document the new skill"
echo "  4. Commit and push — users will receive the update automatically"
echo ""
