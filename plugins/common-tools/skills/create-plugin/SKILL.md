---
name: create-plugin
description: >
  Interactively scaffold a new plugin in this ai-plugin-skeleton repository and register it
  in the marketplace. Use this skill whenever the user wants to create a new plugin, add a plugin,
  scaffold a plugin directory, or set up a new plugin for Claude Code or Copilot CLI.
  Do NOT use for adding a skill to an existing plugin — that only requires creating a SKILL.md file.
---

# Create Plugin

Guide the user through creating a new plugin, then call `scripts/create-plugin.sh` to scaffold
the directory structure and register it in `marketplace.json`.

## Step 1 — Gather information

Collect the following through conversation. Ask all required fields before running the script.

| Field | Required | Notes |
|-------|----------|-------|
| Plugin name | Yes | kebab-case, e.g. `dev-tools` |
| Plugin description | Yes | One sentence describing the plugin's purpose |
| Category | No | Default: `productivity` |
| Tags | No | Comma-separated keywords |
| First skill name | No | kebab-case; omit if user wants an empty plugin |
| First skill description | No | Required if creating a first skill |

**Validation rules (check before running the script):**
- Plugin name must be kebab-case: `^[a-z][a-z0-9-]*[a-z0-9]$` or a single lowercase letter
- Plugin name must not already exist under `plugins/`
- Skill name follows the same kebab-case rule

If the user already provided some or all of this information in their message, extract it directly —
don't ask again for what's already clear.

## Step 2 — Confirm before executing

Send a **text message** (not a form) displaying the summary of what will be created, then ask
a **single Yes/No question** to confirm. Do NOT re-ask for any information already collected.

Example text message to send:
> I'll create the following plugin:
>
>   Plugin : my-plugin
>   Desc   : Does something useful
>   Cat    : productivity
>   Tags   : none
>   Skill  : my-skill — A skill that does X
>
> Shall I proceed?

The confirmation ask_user call must contain only one field: a yes/no choice ("Proceed" / "Cancel").
Do not include plugin name, description, category, tags, skill name, or skill description as fields
in the confirmation — those were already collected in Step 1.

## Step 3 — Run the script

Run `scripts/create-plugin.sh` from the **repository root** in non-interactive mode.

**With a first skill:**
```bash
bash scripts/create-plugin.sh \
  --name <plugin-name> \
  --description "<plugin-description>" \
  --category <category> \
  --tags "<tag1,tag2>" \
  --skill-name <skill-name> \
  --skill-description "<skill-description>"
```

**Without a first skill:**
```bash
bash scripts/create-plugin.sh \
  --name <plugin-name> \
  --description "<plugin-description>" \
  --category <category> \
  --tags "<tag1,tag2>" \
  --no-first-skill
```

Omit `--tags` if no tags were provided. Omit `--category` to use the default (`productivity`).

## Step 4 — Report results

After the script succeeds, show the user:
1. The files that were created (from the script output)
2. The invoke command if a first skill was created: `/<plugin-name>:<skill-name>`

## Step 5 — Offer to flesh out the skill

If a first skill was created (i.e. `--skill-name` was passed to the script), the generated
`SKILL.md` is only a placeholder. Proactively ask the user whether they want to flesh it out now:

> The skill `<skill-name>` was scaffolded with a placeholder SKILL.md.
> Would you like me to help you build it out now using the skill-creator workflow?

If the user says **yes**, read `plugins/common-tools/skills/skill-creator/SKILL.md` and follow
its instructions to help the user define the skill — starting from the "Capture Intent" step,
using `plugins/<plugin-name>/skills/<skill-name>/SKILL.md` as the file to write.

If the user says **no** (or skips), remind them of the pre-commit checklist:
- Edit the skill's SKILL.md to define the actual workflow
- Update `README.md` and `AGENTS.md` to document the new skill
- Bump `plugin.json` version before pushing

## Error handling

- If the script exits non-zero, show the error output to the user and explain what went wrong
- Common issues: plugin name already exists, invalid kebab-case, missing `jq`/`python3` for marketplace registration
