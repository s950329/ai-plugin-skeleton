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

## Required Changes

### 1. `marketplace.json`

Update the marketplace identity and replace the example plugin entry.

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

// After
{
  "name": "my-plugin-marketplace",
  "owner": {
    "name": "my-org",
    "email": "contact@my-org.com"
  },
  "plugins": [
    {
      "name": "my-plugin",
      "description": "What this plugin does.",
      "version": "1.0.0",
      "source": "./plugins/my-plugin",
      "category": "productivity",
      "tags": ["tag1", "tag2"]
    }
  ]
}
```

### 2. `plugins/common-tools/`

Delete the example plugin and create your own:

```bash
# Delete the example plugin
rm -rf plugins/common-tools

# Scaffold a new plugin interactively
bash scripts/create-plugin.sh
```

The script creates the full directory structure including `plugin.json` and the required symlinks under `.claude-plugin/` and `.github/plugin/`.

### 3. `scripts/install.sh`

Update the menu options and plugin names to match your actual plugins.

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

# After
echo "  [1] Install all plugins (my-plugin)"
echo "  [2] Install my-plugin only"
...
install_plugin "my-plugin"
...
printf "  ${CYAN}my-plugin${NC} (General)\n"
echo "    /my-plugin:my-skill  — What this skill does"
```

### 4. `README.md`

Update the following sections:

- **Title and description** — replace `ai-plugin-skeleton` with your project name
- **Getting Started section** — delete the entire `## Getting Started` section (it's for template setup only, not for your end users)
- **Install commands** — replace `your-org/your-repo` with your actual repo path
- **Available Commands table** — replace with your actual skills
- **Updating Plugins** — replace plugin names

### 5. `AGENTS.md`

Update the following sections:

- **Title** — Replace `# AGENTS.md — ai-plugin-skeleton` with your project name
- **§1 Plugin overview table** — Replace `common-tools` row with your plugin(s)
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

## Files You Can Keep As-Is

| File | Why |
|------|-----|
| `scripts/create-plugin.sh` | Generic scaffolding tool — no hardcoded values |
| `.skeleton/templates/` | Plugin templates used by the scaffolding script |
| `CONTRIBUTING.md` | Generic contributor guide |
| `.github/workflows/release.yml` | Auto-discovers plugins dynamically |

---

## Suggested Order

1. Update `marketplace.json`
2. Update `scripts/install.sh`
3. Update `README.md` and `AGENTS.md`
4. Update `LICENSE`
5. Commit and push

---

## Further Reading

- [Plugin Design Guide](./plugin-design-guide.md) — how to organize plugins, write SKILL.md, and avoid common pitfalls
- [Troubleshooting](./troubleshooting.md) — common errors and their solutions
- [References](./references.md) — official docs, community resources, and ecosystem observations
