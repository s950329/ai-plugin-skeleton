# Troubleshooting

Common errors and their solutions when developing and distributing plugins.

---

## Common Errors

| Problem | Cause | Fix |
|---------|-------|-----|
| Users don't see a new skill after push | Forgot to bump `plugin.json` `version` | Bump version and push again |
| `plugin validate` fails | SKILL.md frontmatter syntax error, missing `name` or `description` | Check YAML frontmatter syntax and required fields |
| Copilot CLI silently ignores plugin | Missing `.github/plugin/plugin.json` | Create the symlink pointing to the primary `plugin.json` |
| Works with `--plugin-dir` but not after marketplace install | `marketplace.json` `source` path is wrong | Ensure `source` is relative to the repo root |
| Skill can't read sub-resources (scripts/, references/) | Path error | Use paths relative to SKILL.md, e.g. `./references/file.md` |
| Copilot CLI: `Failed to load N skills` | SKILL.md `name:` field contains colon `:` | Remove namespace prefix from `name` |
| `copilot plugin update` still shows old version | Copilot marketplace cache not refreshed | Clear `~/Library/Caches/copilot/marketplaces/{marketplace-name}/` and reinstall (path may vary by version) |
| `claude plugin update` still shows old version | Claude Code marketplace cache not refreshed | Run `git pull` in `~/.claude/plugins/marketplaces/{marketplace-name}/` (path may vary by version) |
| VS Code: `fatal: destination path already exists` | `agentPlugins` cache conflict | Delete `~/Library/Application Support/Code/agentPlugins/github.com/{org}/{repo}` |
| Plugin not showing in VS Code | Chat plugins not enabled | Confirm `chat.plugins.enabled: true` in VS Code settings |

---

## Plugin Auto-namespace Bug

- **Tracking issues:** `anthropics/claude-code#17271`, `#20994`
- **Symptom:** `plugin.json` `name` field does NOT automatically prefix skill commands
- **Expected:** `/plugin-name:skill-name`
- **Actual:** Sometimes the prefix is not applied
- **Current workaround:** Do not add prefix manually — accept that the namespace mechanism is unstable. Adding prefix manually causes Copilot CLI to fail.
