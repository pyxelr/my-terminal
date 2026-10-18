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
| [`claude/hooks/cdiff`](claude/hooks/cdiff) | `~/.claude/hooks/cdiff` (executable), called by the `cdiff` function in `zshrc` |

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

`claude/hooks/last-edited-repo.sh` tracks what Claude Code edits, and `claude/hooks/cdiff`
(called by the `cdiff` function in `zshrc`, with the `d` and `dif` aliases in `aliases`)
opens it from any directory, without opening herdr or Claude Code in that directory:

- a file inside a git repo is recorded, and `cdiff` opens [herdr-reviewr](https://github.com/persiyanov/herdr-reviewr) on the repo
- a file outside git (an Obsidian vault, say) is copied once before its first edit in a
  session, and `cdiff` shows a [delta](https://github.com/dandavison/delta) diff against that copy.
  Binaries and files over 1 MB are skipped, and copies are deleted after 7 days
- each prompt that touches such a file also gets its own copy (the last 10 are kept), so
  `cdiff 2 1` shows only what the last prompt changed, `cdiff 2 2` the one before it, and `cdiff 2 -l`
  lists them with the first 60 characters of each prompt (kept in the cache for 7 days like the copies)
- `cdiff` opens the most recent edit, `cdiff 2` the second most recent (numbered as in `cdiff --list`, which are not stable once
  a new edit lands), `cdiff -l` picks from recent ones with `fzf` (Enter opens, `q` comes back to the list,
  `ctrl-p` picks a prompt, `ctrl-r` resets a note's baseline, `ctrl-x` removes a row, Esc quits), `cdiff rm 2` or `cdiff rm all`
  clean the list (the registry only, never your files), `cdiff reset 2` (or `cdiff r 2`) or `cdiff reset all` make a
  note's current content its new baseline so the next diff shows only what changes after it (a git
  repo has no baseline of ours, git keeps that), and `cdiff <path>` opens a repo or a copied file
- state lives in `~/.cache/claude-edits/`: one registry row per repo or file, capped at 200 rows,
  and rows older than 30 days are dropped, so it cannot grow without limit
- noise (`~/.claude`, `~/.config`, `~/.cache`, `~/Library`, `/tmp`) is skipped for files outside git. Add
  more globs, one per line, to `~/.config/claude-edits-ignore`
- only edits made through Claude's Edit and Write tools are seen, not `sed -i` or scripts run through Bash

Needs `jq`, `git` and `fzf`, and `delta` for the non-git diffs (it falls back to `less`).
Make both scripts executable, then add this to the `hooks` object in `~/.claude/settings.json`
(next to any existing entries; the file itself is not in this repo because it holds
machine-specific settings):

```json
"PreToolUse": [
  {
    "matcher": "Edit|Write|MultiEdit",
    "hooks": [
      { "type": "command", "command": "$HOME/.claude/hooks/last-edited-repo.sh", "timeout": 10 }
    ]
  }
],
"PostToolUse": [
  {
    "matcher": "Edit|Write|MultiEdit",
    "hooks": [
      { "type": "command", "command": "$HOME/.claude/hooks/last-edited-repo.sh", "timeout": 10 }
    ]
  }
],
"UserPromptSubmit": [
  {
    "hooks": [
      { "type": "command", "command": "$HOME/.claude/hooks/last-edited-repo.sh", "timeout": 10 }
    ]
  }
]
```

Hooks are read when a session starts, so run `/hooks` or open a new session.
