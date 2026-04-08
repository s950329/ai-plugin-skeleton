# ai-plugin-skeleton — Plugin Marketplace

This repo can be used to scaffold an AI skill plugin marketplace. Follow these steps to get started:

1. Press the **"Use this template"** button at the top of this repo to create a new repo with the contents of this skeleton.
2. Tell your AI agent to customize the skeleton by pasting: `Customize this plugin skeleton for my project by following the guide in: @docs/get-started.md`
3. Or follow the [Get Started](./docs/get-started.md) guide manually to replace all placeholders throughout the files.
4. Have fun creating your plugins.

---

## Quick Install

```bash
./scripts/install.sh
```

The script auto-detects available CLI tools (claude / copilot) and guides you through selecting which plugins to install.

## Plugin Installation Guide

> The examples below use `your-org/your-repo` as a placeholder — replace it with your actual repo path.

### GitHub Copilot CLI

```bash
copilot plugin marketplace add your-org/your-repo
copilot plugin install common-tools@your-repo
```

### Claude Code

```bash
claude plugin marketplace add your-org/your-repo
claude plugin install common-tools@your-repo
```

### VS Code Installation

If you use Claude Code or Copilot inside VS Code, follow these steps:

#### Step 1: Enable Plugin Support & Add the Marketplace

Open **Settings** (`Cmd + ,`) and search for `plugin`:

1. Check **Chat > Plugins: Enabled** to enable agent plugin support.
2. Under **Chat > Plugins: Marketplaces**, click `Add Item` and enter your repo path (e.g. `your-org/your-repo`).

#### Step 2: Install a Plugin

Go to the **Extensions** sidebar, search for `@agentPlugins`, and click **Install** on any plugin you want.

After installing, type `/` in VS Code Chat to see the list of available skills.

## Claude.ai Web Installation (No CLI Required)

If you don't use the CLI or VS Code, you can install skills directly into Claude.ai from a GitHub Release:

1. Go to the [Releases page](../../releases) and download the zip file you need.
2. Unzip it — inside you'll find one or more `.skill` files (each file is a standalone skill).
3. Go to [Claude.ai](https://claude.ai), open the left menu, and navigate to **Customize** → **Skills** → **Create skill** → **Upload a skill**.
4. Upload the `.skill` file you want.
5. Type `/` in a conversation to confirm the skill appears in the available command list.

> Each `.skill` file can be installed independently — you don't need to upload all of them.

## Available Commands After Install

### common-tools (General)

| Command | Description |
|---------|-------------|
| `/common-tools:skill-creator` | Create, evaluate, and package skills |
| `/common-tools:create-plugin` | Scaffold a new plugin and register it in the marketplace |

## Creating a New Plugin

### For Agents

Copy and paste this prompt to your LLM agent (Claude Code, AmpCode, Cursor, etc.):

```
Create a new plugin in this repository by following the instructions in:
@plugins/common-tools/skills/create-plugin/SKILL.md
```

The agent will ask you a few questions and then scaffold everything automatically.

Or if the `common-tools` plugin is already installed, just type `/common-tools:create-plugin` in Claude Code or Copilot CLI.

### For Humans

```bash
bash scripts/create-plugin.sh
```

The script walks you through the same questions interactively and produces the same result.

---

## Updating Plugins

Plugins are checked for updates automatically when the CLI starts. To update manually:

### GitHub Copilot CLI

```bash
copilot plugin update common-tools@your-repo
```

### Claude Code

```bash
claude plugin update common-tools@your-repo
```

---

> For directory structure details, see [AGENTS.md](./AGENTS.md#2-directory-structure).<br>
> Want to contribute? Read [CONTRIBUTING.md](./CONTRIBUTING.md).<br>
> AI coding agents maintaining this repo should refer to [AGENTS.md](./AGENTS.md).<br>
> Template developers: [Get Started](./docs/get-started.md) · [Plugin Design Guide](./docs/plugin-design-guide.md) · [Troubleshooting](./docs/troubleshooting.md) · [References](./docs/references.md)
