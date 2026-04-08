# References

Official documentation, community resources, and ecosystem observations for plugin marketplace development.

---

## Official Documentation

### Claude Code (Anthropic)

| Topic | URL | Key points |
|-------|-----|------------|
| Skills | https://code.claude.com/docs/en/skills | SKILL.md frontmatter spec, sub-resource directories, relative paths |
| Plugin discovery & install | https://code.claude.com/docs/en/discover-plugins | `plugin marketplace add`, official marketplace, Discover/Errors tabs |
| Creating marketplaces | https://code.claude.com/docs/en/plugin-marketplaces | `marketplace.json` schema, source types (github/url/git-subdir/local), version pinning with `@ref` / `#ref` |
| Docs sitemap | https://docs.anthropic.com/en/docs/claude-code/claude_code_docs_map.md | Full docs index |
| Official marketplace catalog | https://claude.com/plugins | Browse Anthropic-maintained plugins |
| Official marketplace repo | https://github.com/anthropics/claude-plugins-official | Submission and review process |
| Demo marketplace | https://github.com/anthropics/claude-code | Example plugins: `agent-sdk-dev`, `pr-review-toolkit`, `frontend-design`, etc. |

**Key concepts:**

- Marketplace is a two-step process: `marketplace add` (register catalog) → `plugin install` (install individually)
- Official marketplace `claude-plugins-official` is available by default — no need to `add` first
- Supported source types: `github` (owner/repo), `url` (any git URL), `git-subdir`, `local path`, `remote URL`
- Pin versions: GitHub shorthand uses `@ref` (e.g. `acme/plugins@v1.2.0`), git URLs use `#ref`
- Marketplace state stored at: `~/.claude/plugins/known_marketplaces.json` (per-user, not per-project)
- CI/container environments: use `CLAUDE_CODE_PLUGIN_SEED_DIR` env var to pre-seed plugin directories
- Schema URL: `https://anthropic.com/claude-code/marketplace.schema.json` (add `$schema` field for IDE autocomplete)

### GitHub Copilot CLI

| Topic | URL | Key points |
|-------|-----|------------|
| Plugin concepts | https://docs.github.com/en/copilot/concepts/agents/copilot-cli/about-cli-plugins | Plugin components: custom agents, skills, hooks, MCP, LSP |
| Installing plugins | https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-finding-installing | `copilot plugin marketplace add`, install from git repo, sub-path syntax |
| Creating marketplaces | https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/plugins-marketplace | `.github/plugin/` or `.claude-plugin/` placement |
| Plugin schema reference | https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference | Full `plugin.json` field list, default paths for agents/skills/hooks/mcpServers |
| Copilot CLI product page | https://github.com/features/copilot/cli | `/plan`, `/fleet`, `/mcp`, AGENTS.md integration |

**Key concepts:**

- Two default marketplaces: `copilot-plugins` (GitHub) and `awesome-copilot` (community) — available without `add`
- Install from sub-path: `copilot plugin install owner/repo:path/to/plugin`
- Plugin detection: repo must contain `plugin.json` in `.plugin/`, `.github/plugin/`, `.claude-plugin/`, or repo root
- Marketplace name should be limited to `A-z`, `0-9`, dash — same as plugin name

### VS Code Agent Plugins (Preview)

| Topic | URL | Key points |
|-------|-----|------------|
| Agent plugins docs | https://code.visualstudio.com/docs/copilot/customization/agent-plugins | `chat.plugins.enabled`, `chat.plugins.marketplaces`, `extraKnownMarketplaces` |

**Key concepts:**

- Preview feature — requires `chat.plugins.enabled: true`
- Plugin can contain: slash commands, agent skills, custom agents, hooks, MCP servers
- Three marketplace source formats: shorthand (`owner/repo`), git URL, local path
- Local storage: macOS `~/Library/Application Support/Code/agentPlugins/github.com/{ORG}/{REPO}`
- Local dev: use `chat.plugins.paths` to point to local plugin directory
- Team setup: `.claude/settings.json` with `extraKnownMarketplaces` for automatic team install

### Claude.ai / Cowork (Team/Enterprise)

| Topic | URL | Key points |
|-------|-----|------------|
| Cowork plugin management | https://support.claude.com/en/articles/13837433-manage-cowork-plugins-for-your-organization | Org-level plugin management, GitHub auto-sync |

**Key concepts:**

- Team / Enterprise plan owner can manage org plugins
- Two upload methods: manual zip upload, GitHub repo auto-sync
- GitHub sync: PR merge to main triggers auto-sync (if "Sync automatically" is enabled)
- Plugin naming: must be lowercase + hyphen (`deployment-tools` OK, `Deployment Tools` NOT OK)
- Limits: zip max 50 MB, marketplace max 100 plugins
- Install preferences (per-plugin): auto-install / available / disabled / blocked

---

## Community & Third-party Resources

### Template / Skeleton References

| Name | URL | What to learn |
|------|-----|---------------|
| spatie/package-skeleton-laravel | https://github.com/spatie/package-skeleton-laravel | Gold standard for skeleton repos: `Use this template` + interactive `configure.php` + self-deleting script |
| ivan-magda/claude-code-plugin-template | https://github.com/ivan-magda/claude-code-plugin-template | Claude Code plugin template with built-in scaffolding, validation, CI/CD |
| hyperskill/claude-code-marketplace | https://github.com/hyperskill/claude-code-marketplace | Internal marketplace example using `extraKnownMarketplaces` for team auto-install |
| mrlm-xyz/demo-claude-marketplace | https://github.com/mrlm-xyz/demo-claude-marketplace | Private marketplace tutorial showing plugins + project config + settings interaction |
| feed-mob/claude-code-marketplace | https://github.com/feed-mob/claude-code-marketplace | Real enterprise marketplace example with multiple business plugins |

### Marketplace & Skill Discovery

| Name | URL | What it does |
|------|-----|--------------|
| claudemarketplaces.com | https://claudemarketplaces.com/ | Third-party index (2,500+ marketplaces, 2,500+ skills) |
| clawhub.ai | https://clawhub.ai/ | Skill security scanning — marks each skill as Benign / Suspicious / Malicious |
| aitmpl.com/plugins | https://www.aitmpl.com/plugins/ | 340+ plugins, 1,367+ agent skills index |
| awesome-copilot | https://awesome-copilot.github.com/plugins/ | Official community marketplace for Copilot, default in VS Code |

### Plugin Examples (for studying structure)

| Name | URL | What to learn |
|------|-----|---------------|
| anthropics/claude-code | https://github.com/anthropics/claude-code | Anthropic's own plugin structure (`plugins/agent-sdk-dev`, `pr-review-toolkit`, etc.) |
| anthropics/claude-plugins-official | https://github.com/anthropics/claude-plugins-official | Official reviewed marketplace, submission at `platform.claude.com/plugins/submit` |
| tanweai/pua | https://github.com/tanweai/pua | Cross-platform skill (Claude Code, Codex CLI, OpenClaw, Antigravity) |
| kenmuse blog | https://www.kenmuse.com/blog/creating-agent-plugins-for-vs-code-and-copilot-cli/ | Tutorial on Copilot CLI plugins — confirms `plugin.json` must be in `.github/` subdirectory |

### Enterprise Internal Marketplace

| Name | URL | What to learn |
|------|-----|---------------|
| LiteLLM Plugin Marketplace | https://docs.litellm.ai/docs/tutorials/claude_code_plugin_marketplace | Self-hosted marketplace via LiteLLM proxy with admin UI |
| classmethod cross-repo tutorial | https://dev.classmethod.jp/en/articles/claude-code-marketplace-source-external-repo/ | Using `source: { url }` to reference plugins from external repos |

---

## Ecosystem Observations

### SKILL.md is becoming a cross-tool standard

`tanweai/pua` supports Claude Code, Codex CLI, OpenClaw, and Antigravity simultaneously. SKILL.md is the de facto standard for AI coding agents — skills you write today will likely work across future tools.

### Plugin components are expanding

Plugins can now contain far more than just skills:

- **Skills** (`skills/{name}/SKILL.md`)
- **Agents** (`agents/*.agent.md`)
- **Slash commands** (`commands/*.md`)
- **Hooks** (`hooks.json`)
- **MCP servers** (`.mcp.json`)
- **LSP servers** (`lsp.json`)

### Source types support cross-repo architecture

`marketplace.json` `source` field supports referencing plugins from external repos:

```json
{
  "source": {
    "source": "github",
    "repo": "another-org/another-repo"
  }
}
```

This means you can split plugins across multiple repos if different teams maintain them.

### Security risks are real

Third-party skills can involve supply chain risks, API key exposure, browser cookie access, and background daemons. ClawHub rates skills as Benign / Suspicious / Malicious. For enterprise environments, establish a review process before adopting external skills.

### Official marketplace has a review process

Submit to `claude-plugins-official` via `platform.claude.com/plugins/submit` for Anthropic review. Consider this if you want your plugins widely adopted.
