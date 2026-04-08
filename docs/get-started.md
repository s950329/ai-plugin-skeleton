# Get Started: Customizing This Template

This guide walks through every file you need to change after forking or using this skeleton as a template.

## What's Included

### Plugin Overview

| Plugin | Skills | Users |
|--------|--------|-------|
| `common-tools` | skill-creator, create-plugin | All roles |

### Directory Structure

> See [AGENTS.md](../AGENTS.md#2-directory-structure) for the full structure.

```
ai-plugin-skeleton/
├── plugins/
│   └── common-tools/       ← example plugin
├── scripts/                ← install script
├── AGENTS.md               ← AI agent instructions
├── CONTRIBUTING.md         ← contributor guide for humans
└── README.md
```

---

## Before You Start

Decide the following:

1. **Plugin name**: Keep `common-tools` or rename to something else (e.g. `my-tools`, `dev-utils`)? If renaming, the directory, `plugin.json`, symlinks, and all references must be updated together.
2. **Marketplace identity**: your org name, email, and repo path.

---

## Required Changes

### 1. `marketplace.json`

Update the marketplace identity. If renaming the plugin, also update the plugin entry's `name` and `source`.

```json
// Before
{
  "name": "ai-plugin-skeleton",
  "owner": {
    "name": "your-org",
    "email": "dev@example.com"
  },
  "plugins": [
    {
      "name": "common-tools",
      "description": "Common workflow tools for all roles.",
      "version": "1.0.0",
      "source": "./plugins/common-tools",
      "category": "productivity",
      "tags": ["skill", "creator", "evaluation"]
    }
  ]
}

// After (example with rename)
{
  "name": "my-plugin-marketplace",
  "owner": {
    "name": "my-org",
    "email": "contact@my-org.com"
  },
  "plugins": [
    {
      "name": "my-tools",
      "description": "What this plugin does.",
      "version": "1.0.0",
      "source": "./plugins/my-tools",
      "category": "productivity",
      "tags": ["tag1", "tag2"]
    }
  ]
}
```

### 2. `plugins/common-tools/` — Rename or keep

The bundled `common-tools` plugin includes useful skills (skill-creator, create-plugin). You do NOT need to delete it.

**If keeping the name `common-tools`:** Skip this step entirely.

**If renaming** (e.g. to `my-tools`):

```bash
# Rename the directory
mv plugins/common-tools plugins/my-tools

# Update plugin.json name field
# Edit plugins/my-tools/plugin.json → change "name" to "my-tools"

# Recreate symlinks (old ones break after rename)
cd plugins/my-tools
rm -f .claude-plugin/plugin.json .github/plugin/plugin.json
ln -s ../plugin.json .claude-plugin/plugin.json
ln -s ../../plugin.json .github/plugin/plugin.json
cd ../..
```

> **Important:** The directory name, `plugin.json` `name`, and `marketplace.json` plugin entry `name` + `source` must all match. Keep `version` at `1.0.0` for a new project.

### 3. `scripts/install.sh`

Update the menu options and plugin names to match your actual plugin name.

Lines to change (around line 83–137):

```bash
# Before
echo "  [1] Install all plugins (common-tools)"
echo "  [2] Install common-tools only"
...
install_plugin "common-tools"
...
printf "  ${CYAN}common-tools${NC} (Common)\n"
echo "    /common-tools:skill-creator  — Create, evaluate, and package skills"

# After (example with rename to my-tools)
echo "  [1] Install all plugins (my-tools)"
echo "  [2] Install my-tools only"
...
install_plugin "my-tools"
...
printf "  ${CYAN}my-tools${NC} (General)\n"
echo "    /my-tools:skill-creator  — Create, evaluate, and package skills"
```

### 4. `README.md`

Update the following sections:

- **Title and description** — replace `ai-plugin-skeleton` with your project name
- **Getting Started steps** — delete the 4-step getting started block at the top (it's for template setup only, not for your end users)
- **Install commands** — replace `your-org/your-repo` with your actual repo path, replace `common-tools` with your plugin name
- **Available Commands table** — replace with your actual plugin name and skills
- **Updating Plugins** — replace plugin names

### 5. `AGENTS.md`

Update the following sections:

- **Title** — Replace `# AGENTS.md — ai-plugin-skeleton` with your project name
- **§1 Plugin overview table** — Replace `common-tools` row with your plugin name
- **§2 Directory structure** — Replace `ai-plugin-skeleton/` and `common-tools/` with actual names

### 6. `LICENSE`

Replace the copyright holder:

```
// Before
Copyright (c) 2026 Leo Chien

// After
Copyright (c) 2026 Your Name or Organization
```

---

## Do Not Modify

| File / Path | Why |
|-------------|-----|
| `plugins/*/skills/*/SKILL.md` | Skill content is not part of template customization. Only modify if you want to change a skill's behavior. |
| `docs/*.md` | These are template documentation files. Delete them after customization is complete — no need to rewrite their content. |
| `version` fields | Keep at `1.0.0` for a new project. Do not bump during initial customization. |

---

## Files You Can Keep As-Is

| File | Why |
|------|-----|
| `scripts/create-plugin.sh` | Generic scaffolding tool — no hardcoded values |
| `.skeleton/templates/` | Plugin templates used by the scaffolding script |
| `CONTRIBUTING.md` | Generic contributor guide |
| `.github/workflows/release.yml` | Auto-discovers plugins dynamically |

---

## Suggested Order

1. Decide: keep `common-tools` or rename?
2. Update `marketplace.json`
3. Rename `plugins/common-tools/` if needed (directory + plugin.json + symlinks)
4. Update `scripts/install.sh`
5. Update `README.md` and `AGENTS.md`
6. Update `LICENSE`
7. Delete `docs/get-started.md` and other template docs
8. Commit and push

---

## Further Reading

- [Plugin Design Guide](./plugin-design-guide.md) — how to organize plugins, write SKILL.md, and avoid common pitfalls
- [Troubleshooting](./troubleshooting.md) — common errors and their solutions
- [References](./references.md) — official docs, community resources, and ecosystem observations
