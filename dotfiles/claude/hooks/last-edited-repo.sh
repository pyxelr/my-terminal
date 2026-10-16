#!/bin/bash
# PostToolUse hook: remember the git root of the file Claude just edited,
# so `cdiff` can open the diff viewer there from any directory.
f=$(jq -r '.tool_input.file_path // empty')
[ -n "$f" ] || exit 0
root=$(git -C "$(dirname "$f")" rev-parse --show-toplevel 2>/dev/null) || exit 0
printf '%s\n' "$root" > ~/.cache/claude-last-repo
