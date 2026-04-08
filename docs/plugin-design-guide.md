# Plugin Design Guide

How to organize plugins and write effective skills.

---

## Plugin Grouping Strategy

### Group by user role

| Plugin | Target users | Examples |
|--------|-------------|----------|
| `dev-tools` | Engineers | commit, code-review, skill-creator, mcp-builder |
| `pm-tools` | PMs / Ops | prd-writer, api-documentation-generator |
| `common-tools` | All roles | prompt-review |

### Deciding where a skill belongs

- **`common-tools`**: Valuable for all roles, requires no domain-specific knowledge.
- **`dev-tools`**: Primarily for engineers — involves git, CI, build, dependency management.
- **`pm-tools`**: Primarily for PMs or ops — involves requirement docs, API onboarding, business automation.

> Grouping is not a hard rule — go by actual users. For example, `code-review` was initially in `common-tools` (PMs might look at code), but in practice it fits better in `dev-tools`.

---

## Writing SKILL.md

### Frontmatter

```yaml
---
name: my-skill-name
description: >
  One sentence describing what the skill does.
  Trigger when the user mentions "keyword1", "keyword2", or similar phrases.
  Also describe when this skill should NOT be used.
---
```

**Field rules:**

| Field | Rule |
|-------|------|
| `name` | kebab-case. **Do not add a namespace prefix** (e.g. `dev-tools:`) — causes Copilot CLI to fail loading. Allowed characters: alphanumeric, hyphen (`-`), underscore (`_`), dot (`.`), space. No colon `:`. |
| `description` | First sentence: core function. Then: trigger keywords (English + Chinese). Then: when NOT to use. |

### Recommended body structure

1. **Role definition** — who or what the skill acts as
2. **Workflow** — step-by-step process (Step 1 / 2 / 3)
3. **Output format** — what the skill produces
4. **Constraints** — hard rules and guardrails

### Sub-resource directories

| Directory | Purpose | When to use |
|-----------|---------|-------------|
| `references/` | Reference docs, code snippets | Skill needs to reference existing code or external specs |
| `scripts/` | Executable scripts | Skill needs to run validation, generate reports, or other automation |
| `agents/` | Sub-agent definitions | Skill needs to be split into multiple cooperating agents |
| `assets/` | Static resources (html, images) | UI templates, report templates |

**Path rule:** In SKILL.md, use paths relative to SKILL.md itself, e.g. `./references/schema.md`.

---

## Anti-patterns

- **Stuffing all skills into one plugin** — defeats the purpose of grouping. Users can't selectively install what they need.
- **Adding namespace prefix to SKILL.md `name:`** — e.g. `dev-tools:commit`. Copilot CLI fails to load the skill.
- **Changing skill content without bumping version** — users with the plugin installed will never receive the update due to caching.
- **`.claude-plugin/` and `.github/plugin/` out of sync** — the two CLIs behave differently, hard to debug. (This skeleton avoids the issue by using symlinks to a single primary file, but the risk applies if you maintain separate copies.)
- **Using `marketplace.json` top-level `version` to control updates** — that field has no effect. Only `plugin.json` `version` matters.

---

## Key Design Decisions

| Decision | Conclusion | Reason |
|----------|-----------|--------|
| Plugin grouping | By role (dev / pm / common) | Intuitive for users, easy to self-select |
| Metadata dual-path | Symlinks in `.claude-plugin/` + `.github/plugin/` pointing to a single primary file | Compatible with both Claude Code and Copilot CLI, no sync issues |
| Release version format | Date + sequence number (`v{YYYY.MM.DD}-{N}`) | Fully automatic, no manual bumping needed |
| Packaging granularity | Per plugin | Users can download selectively |
| Skill packaging unit | One `.skill` file per skill | Matches Claude.ai upload mechanism |
| Configure script | Agent-first prompt + shell fallback | Cross-platform, good experience |
| Skeleton built-in tools | Full skill-creator included | Continuously usable scaffolding tool |
