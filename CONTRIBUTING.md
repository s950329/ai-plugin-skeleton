> AI coding agents: see [AGENTS.md](./AGENTS.md) for machine-readable instructions.

# Contributing Guide

Thank you for your interest in contributing! Please read this document along with `README.md` and `AGENTS.md` before making any changes, to ensure your contribution aligns with the project's current conventions.

## Before You Start

1. **Identify what you want to change**
   - For adding or modifying a skill, find the corresponding `plugins/{plugin-name}/skills/{skill-name}/SKILL.md`.
   - For plugin configuration, edit `plugins/{plugin-name}/plugin.json` (the files under `.claude-plugin/` and `.github/plugin/` are symlinks — you don't need to edit them separately).
   - For documentation updates, check whether `README.md` or `AGENTS.md` also needs to be synced.

2. **Create your own working branch first**
   - Branch off from `main` before making any changes.
   - Use a descriptive branch name so others immediately understand its purpose.
   - Do not work directly on `main`.

3. **Keep changes small and focused**
   - Each PR should address a single topic.
   - Avoid mixing unrelated formatting tweaks, refactors, and feature changes in the same PR.

## Development Workflow

1. Branch off the latest `main`.
2. Make your changes on the branch.
3. Review your own changes and run any necessary validation.
4. Submit via Pull Request.
5. Address review feedback and make any required fixes.

## Special Rules When Changing Skills

If you are modifying skill content, follow these rules:

- **JSON config files are maintained via symlinks**
  - The primary `marketplace.json` lives at the project root; files under `.claude-plugin/` and `.github/plugin/` are symlinks.
  - The primary `plugin.json` lives at `plugins/{plugin-name}/plugin.json`; files under `.claude-plugin/` and `.github/plugin/` are symlinks.
  - Edit only the primary file — symlinks sync automatically.

- **Bump the version when skill content changes**
  - Update the `version` in the corresponding `plugins/{plugin-name}/plugin.json`.
  - Also update the matching plugin entry `version` in the root `marketplace.json` to keep it in sync.
  - This ensures existing users receive the update, and the marketplace display version matches the installed version.

- **Sync docs when the skill list changes**
  - If you add, remove, move, or rename a skill, update both `README.md` and `AGENTS.md`.

## Validation Checklist

Before submitting a PR, complete at least the validations relevant to your changes:

- Check that config file formatting is correct.
- Confirm symlinks are intact (files under `.claude-plugin/` and `.github/plugin/` should point to the primary files).
- If your change involves a skill, confirm `version` has been correctly updated.
- If there are corresponding tests or validation scripts, run them and verify the results.

If you modified a plugin or skill, also check:

- That the `README.md` description is still accurate.
- That the workflow and directory descriptions in `AGENTS.md` are still consistent.

## Pull Request Requirements

**All changes must be submitted via Pull Request.**

- Direct commits to `main` are not allowed.
- Merging to `main` without review is not allowed.
- This applies even to small patches, doc fixes, and config tweaks.

Each PR should include:

- A summary of changes
- The reason or background for the change
- Validation method and results

## Review and Merge

- Respond to review comments and make required corrections.
- Merge only after the review is approved and all required checks pass.
- If a change is too large in scope, consider splitting it into multiple PRs to make review easier.

## Pre-commit Checklist

- [ ] Read `README.md` and `AGENTS.md`
- [ ] Branched off from `main`
- [ ] Completed required validation
- [ ] No direct commits or merges to `main`
- [ ] If skill content changed: updated `version` in `plugins/{plugin-name}/plugin.json`
- [ ] If skill list changed: synced `README.md` and `AGENTS.md`
- [ ] Submitted via Pull Request

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| Skill not visible after adding it | Forgot to bump `version` in `plugin.json` | Bump version and push again |
| `plugin validate` fails | SKILL.md frontmatter format error, missing `name` or `description` | Check YAML frontmatter syntax and required fields |
| Copilot CLI not loading the plugin | `.github/plugin/plugin.json` symlink is broken | Confirm the symlink points to the correct primary file |
| `--plugin-dir` works but marketplace install doesn't | `source` path in `marketplace.json` is wrong | Confirm `source` is relative to the repo root and points to the correct plugin directory |
| Sub-resources (scripts/, references/) not found | Wrong path | Use paths relative to SKILL.md, e.g. `./references/file.md` |
| Copilot CLI shows `Failed to load N skills` on startup | SKILL.md `name:` field contains disallowed characters (e.g. colon `:`) | `name` may only contain alphanumerics, hyphens, underscores, dots, and spaces — do not manually add a namespace prefix |

## One-line Principle

**Branch first, change second, submit via Pull Request — never touch `main` directly.**
