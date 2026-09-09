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
