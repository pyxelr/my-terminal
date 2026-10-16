# dotfiles

The configuration behind the setup described in the [main README](../README.md),
copied verbatim except where noted. Nothing here is generated: these are the
files actually in use.

| File | Goes to |
|------|---------|
| [`ghostty/config.ghostty`](ghostty/config.ghostty) | `~/Library/Application Support/com.mitchellh.ghostty/config.ghostty` |
| [`herdr/config.toml`](herdr/config.toml) | `~/.config/herdr/config.toml` |
| [`herdr/plugins/config/persiyanov.reviewr/config.toml`](herdr/plugins/config/persiyanov.reviewr/config.toml) | same path under `~/.config/` |
| [`nvim/lua/config/autocmds.lua`](nvim/lua/config/autocmds.lua) | `~/.config/nvim/lua/config/autocmds.lua` |
| [`nvim/lua/plugins/git.lua`](nvim/lua/plugins/git.lua) | `~/.config/nvim/lua/plugins/git.lua` |
| [`starship.toml`](starship.toml) | `~/.config/starship.toml` |
| [`zshrc`](zshrc) | `~/.zshrc` |
| [`aliases`](aliases) | `~/.aliases`, sourced from the last line of `zshrc` |
| [`AGENTS.md`](AGENTS.md) | `~/AGENTS.md` |
| [`claude/CLAUDE.md`](claude/CLAUDE.md) | `~/.claude/CLAUDE.md`, which just points at `~/AGENTS.md` |
| [`claude/hooks/last-edited-repo.sh`](claude/hooks/last-edited-repo.sh) | `~/.claude/hooks/last-edited-repo.sh` (executable), registered in `~/.claude/settings.json` as described [below](#claude-code-hook) |

Two files differ slightly from the originals, so that they are useful to
someone who is not me:

- `starship.toml` — the Kubernetes context aliases are named `sandbox`, `dev`,
  `staging` and `prod` rather than the real cluster names. The point of the
  block is the `context_pattern` matching, which is unchanged.
- `aliases` — the keylight address is a `<keylight-ip>` placeholder.

`AGENTS.md` drops a section of work-specific cluster authentication steps,
including session identifiers. What remains is the general working agreement I
give every agent tool, which is the part worth sharing.

`zshrc` also drops a block that exported a corporate CA bundle, and uses
`$HOME` in place of an absolute home directory. Everything else is as-is, so
expect to prune the parts you do not use (conda, pyenv, podman, nvm, bun).

## Claude Code hook

`claude/hooks/last-edited-repo.sh` records the git root of the file Claude Code
just edited in `~/.cache/claude-last-repo`, and the `cdiff` function in `zshrc`
(with the `d` and `dif` aliases in `aliases`) opens [reviewr](https://github.com/persiyanov/herdr-reviewr) on it. Together
they show the diff of whatever repo the agent touched, without opening herdr or
Claude Code in that directory. Needs `jq` and `git`.

Make the script executable, then add this to the `hooks` object in
`~/.claude/settings.json` (next to any existing `PostToolUse` entries; the file
itself is not in this repo because it holds machine-specific settings):

```json
"PostToolUse": [
  {
    "matcher": "Edit|Write|MultiEdit",
    "hooks": [
      {
        "type": "command",
        "command": "$HOME/.claude/hooks/last-edited-repo.sh",
        "timeout": 10
      }
    ]
  }
]
```

Hooks are read when a session starts, so run `/hooks` or open a new session.
Files outside a git repo are ignored, and the last edit from any session wins.
