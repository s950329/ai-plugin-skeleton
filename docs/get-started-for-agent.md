# Get Started: Agent Instructions

You are helping the user customize this plugin skeleton template for their project. Follow the steps below in order. The detailed reference for each step is in [get-started.md](./get-started.md).

---

## Step 0: Gather Information

Ask the user the following before making any changes:

1. **Project name** — what should this marketplace/repo be called?
2. **Plugin name** — keep `common-tools` or rename to something else? (The bundled skills like skill-creator and create-plugin will be preserved either way.)
3. **Owner info** — org name, contact email, and GitHub repo path (e.g. `my-org/my-repo`).

Wait for the user's answers before proceeding.

---

## Step 1: Update `marketplace.json`

Edit the root `marketplace.json`:
- Replace `name`, `owner.name`, `owner.email`
- If renaming the plugin: update the plugin entry's `name`, `description`, `source`
- If keeping `common-tools`: only update `name` and `owner` fields

---

## Step 2: Rename or keep `plugins/common-tools/`

**If the user chose to keep `common-tools`:** skip this step.

**If renaming** to `{new-name}`:

```bash
mv plugins/common-tools plugins/{new-name}
```

Then edit `plugins/{new-name}/plugin.json` — change `name` to `{new-name}`.

Then recreate the symlinks (they break after directory rename):

```bash
cd plugins/{new-name}
rm -f .claude-plugin/plugin.json .github/plugin/plugin.json
ln -s ../plugin.json .claude-plugin/plugin.json
ln -s ../../plugin.json .github/plugin/plugin.json
```

---

## Step 3: Update `scripts/install.sh`

Replace all occurrences of `common-tools` with the plugin name (around line 83–137): menu text, `install_plugin` calls, and the summary section.

---

## Step 4: Update `README.md`

- Replace `ai-plugin-skeleton` with the project name in title and description
- Delete the 4-step getting started block at the top
- Replace `your-org/your-repo` with the actual repo path in all install commands
- Replace `common-tools` with the plugin name in Available Commands table and Updating Plugins section

---

## Step 5: Update `AGENTS.md`

- Replace `ai-plugin-skeleton` in the title
- Update the plugin overview table (§1)
- Update the directory structure diagram (§2)

---

## Step 6: Update `LICENSE`

Replace the copyright holder name.

---

## Step 7: Clean up template docs

Delete the `docs/` directory — it contains template documentation that is no longer needed after customization.

---

## Hard Rules

- **Do NOT modify any `SKILL.md` files** inside `plugins/*/skills/*/`. Skill content is not part of template customization.
- **Do NOT modify `docs/*.md` content** — delete them at the end, don't rewrite them.
- **Keep `version` at `1.0.0`** in both `plugin.json` and `marketplace.json`. This is a new project — do not bump the version.
- **Directory name must match plugin name.** If `plugin.json` says `"name": "my-tools"`, the directory must be `plugins/my-tools/` and the `marketplace.json` `source` must be `./plugins/my-tools`.
