# AGENTS.md — ai-plugin-skeleton

> For human contributors, see [CONTRIBUTING.md](./CONTRIBUTING.md).

## 1. Project Overview

An AI skill plugin skeleton published in Plugin Marketplace format, compatible with both **Claude Code** and **GitHub Copilot CLI**.

Skills are grouped by user role into plugins:

| Plugin | Description | Target Users |
|--------|-------------|--------------|
| `common-tools` | General-purpose tools: skill creation and evaluation | All roles |

> When using this skeleton, add plugins and skills as needed.

---

## Boundaries

- **Always**: Bump `plugin.json` version before pushing; verify symlinks point to the correct primary file; sync README.md and AGENTS.md whenever the skill list changes.
- **Ask first**: Creating a brand-new plugin, deleting files, renaming an existing skill, modifying CI configuration.
- **Never**: Push directly to `main`; merge a PR without review.

---

## 2. Directory Structure

```
ai-plugin-skeleton/
├── marketplace.json              # Marketplace definition (primary file)
├── .claude-plugin/
│   └── marketplace.json          # → ../marketplace.json (symlink, read by Claude Code)
├── .github/
│   └── plugin/
│       └── marketplace.json      # → ../../marketplace.json (symlink, read by Copilot CLI)
├── plugins/
│   └── common-tools/             # Example plugin
│       ├── plugin.json           # Plugin manifest (primary file)
│       ├── .claude-plugin/
│       │   └── plugin.json       # → ../plugin.json (symlink)
│       ├── .github/
│       │   └── plugin/
│       │       └── plugin.json   # → ../../plugin.json (symlink)
│       └── skills/
│           └── skill-creator/
│               └── SKILL.md
├── scripts/
│   └── install.sh                # One-click install script
├── AGENTS.md                     # This file
├── CONTRIBUTING.md               # Contributor guide for humans
└── README.md
```

---

## 3. Complete Flow for Adding a Skill

### 3a. Choose a Plugin

Pick an existing plugin that fits the target user role, or create a new one.

If none of the existing plugins are a good fit, follow [3d. Register in the marketplace](#3d-register-in-the-marketplace) to create a new plugin.

### 3b. Create SKILL.md

File location: `plugins/{plugin-name}/skills/{skill-name}/SKILL.md`

**Frontmatter template:**

```yaml
---
name: my-skill-name
description: >
  One sentence describing what the skill does. Then list specific trigger conditions:
  trigger when the user mentions "keyword1", "keyword2", or similar phrases.
  Also describe when this skill should NOT be used.
---
```

**Required fields:**
- `name`: kebab-case — **do not add a namespace prefix** (e.g. `dev-tools:`) — this causes Copilot CLI to fail loading the skill.
- `description`: First sentence states the core function; list trigger keywords; describe inapplicable situations.

**Recommended SKILL.md body structure:** Role definition → Workflow → Output format → Constraints

### 3c. Attach Sub-resources

| Directory | Purpose | When to use |
|-----------|---------|-------------|
| `references/` | Reference docs, code snippets | Skill needs to reference existing code or external specs |
| `scripts/` | Executable scripts | Skill needs to run validation, generate reports, or other automation |
| `agents/` | Sub-agent definitions | Skill needs to be split into multiple cooperating agents |

Path references: In SKILL.md, use **paths relative to SKILL.md itself**, e.g. `./references/schema.md`.

### 3d. Register in the Marketplace

- **Adding a skill to an existing plugin**: No changes to `marketplace.json` are needed (`source` points to the whole plugin directory, so new skills are picked up automatically).
- **Creating a brand-new plugin**:
  1. Create the `plugins/{new-plugin}/` directory structure (including `plugin.json`, `.claude-plugin/plugin.json` symlink, `.github/plugin/plugin.json` symlink, and `skills/`).
  2. Add an entry to the `plugins` array in the root `marketplace.json` (symlinks under `.claude-plugin/` and `.github/plugin/` sync automatically):
     ```json
     {
       "name": "new-plugin",
       "description": "Plugin description",
       "version": "1.0.0",
       "source": "./plugins/new-plugin",
       "category": "category",
       "tags": ["tag1", "tag2"]
     }
     ```

### 3e. Version Management

> ⚠️ After modifying any skill content, you **must** bump the `version` in the corresponding plugin's `plugin.json`; otherwise, users who already have it installed will not receive updates due to caching.

Files to keep in sync:
1. `version` in `plugins/{name}/plugin.json` (primary file — symlinks under `.claude-plugin/` and `.github/plugin/` sync automatically).
2. The `version` of the corresponding plugin entry in the root `marketplace.json` (primary file — symlinks sync automatically).

> 📌 The plugin entry `version` in `marketplace.json` is for display purposes, but it **must stay in sync with `plugin.json`** to avoid version discrepancies.

**Semver rules:**
- Modifying skill content → **patch** (1.0.0 → 1.0.1)
- Adding a new skill → **minor** (1.0.0 → 1.1.0)
- Breaking change (removing or renaming a skill) → **major** (1.0.0 → 2.0.0)

### 3f. Validation

```bash
# Structure validation
cd plugins/{plugin-name} && claude plugin validate .

# Local load test (Claude Code)
claude --plugin-dir ./plugins/{plugin-name}

# Local load test (Copilot CLI)
copilot --plugin-dir ./plugins/{plugin-name}
```

Once loaded:
1. Use `/help` to confirm the skill appears in the list.
2. Call `/{plugin-name}:{skill-name}` to confirm it triggers correctly.

### 3g. Sync README and AGENTS.md

When the skill list changes (add, remove, rename, or move a skill), you **must** sync the following files to keep documentation consistent with reality:

| File | Section to update |
|------|-------------------|
| `README.md` | Plugin overview table, install commands, available commands list |
| `AGENTS.md` | §1 project overview table, §2 directory structure |

> ⚠️ This is a mandatory rule, not optional. The commit that changes skills must also include the corresponding documentation updates.

### 3h. Pre-commit Checklist

Before committing, verify the following:

- [ ] **Version bumped**: If skill content changed → `plugin.json` (primary) and the plugin entry `version` in root `marketplace.json` are both bumped and in sync (see [3e. Version Management](#3e-version-management)).
- [ ] **Docs synced**: If the skill list changed → `README.md` and `AGENTS.md` are updated (see [3g. Sync README and AGENTS.md](#3g-sync-readme-and-agentsmd)).
- [ ] **Dual-tool compatibility**: Symlinks under `.claude-plugin/` and `.github/plugin/` correctly point to the primary files (see [§4](#4-dual-tool-compatibility)).

### 3i. Push

After committing, push to the repo. Users who have the marketplace registered will receive updates automatically (provided the version was bumped).

---

## 4. Dual-Tool Compatibility

Config files are maintained as a single primary file; symlinks let both tools read them:

| File | Primary location | Read by Claude Code (symlink) | Read by Copilot CLI (symlink) |
|------|-----------------|-------------------------------|-------------------------------|
| Marketplace definition | `marketplace.json` (repo root) | `.claude-plugin/marketplace.json` | `.github/plugin/marketplace.json` |
| Plugin manifest | `plugins/{name}/plugin.json` | `plugins/{name}/.claude-plugin/plugin.json` | `plugins/{name}/.github/plugin/plugin.json` |

Rule: Edit only the primary file — symlinks sync automatically. When adding a new plugin, create the corresponding symlinks.

---

## 5. Namespace Mechanism

The `name` field in a plugin's `plugin.json` is the namespace prefix. After installation, skills are invoked as `/{plugin-name}:{skill-name}`.

> See [README.md](./README.md#available-commands-after-install) for the full command list.

---

## 6. Installation

> See [README.md](./README.md#quick-install) for the full installation guide.

- One-click install: `bash scripts/install.sh`

---

## 7. Troubleshooting

> See [CONTRIBUTING.md](./CONTRIBUTING.md#troubleshooting) for the full troubleshooting table.

---

## 8. Version Fields Explained

This repo has three places where `version` appears, each serving a different purpose:

| Location | Example | Purpose |
|----------|---------|---------|
| Top-level `version` in `marketplace.json` | `"version": "1.0.0"` | Marketplace catalog version — not used in practice, has no effect on update logic |
| Plugin entry `version` in `marketplace.json` | `plugins[0].version` | Display-only — shown to users browsing the marketplace; **must stay in sync with `plugin.json`** |
| `version` in `plugin.json` | Each plugin directory | **The only version the CLI uses to decide whether an update is needed** — must be bumped on any content change |

> ⚠️ Only the `version` in `plugin.json` is used by the CLI to determine whether an update is required. Forgetting to bump it means users will never receive updates.
> ⚠️ Although the plugin entry `version` in `marketplace.json` does not affect update logic, it should stay in sync with `plugin.json` to avoid displaying a version that differs from the actual installed version.
