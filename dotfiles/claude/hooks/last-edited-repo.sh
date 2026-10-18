#!/bin/bash
# Claude Code hook behind `cdiff` (~/.claude/hooks/cdiff). Best effort and silent:
# it must never block or slow an edit.
#   UserPromptSubmit: number the prompt (turns.tsv: number, time, first 60 characters)
#   PreToolUse:       for a file outside any git repo, keep a baseline copy from before its first
#                     edit in the session, plus one copy per prompt that touches it (last 10)
#   PostToolUse:      record the edit in a small registry, one row per repo or file
# Noise (settings, scratch files) is skipped for non-git files: built-in list below plus
# one glob per line in ~/.config/claude-edits-ignore (matched against the path as given and
# with symlinks resolved).

dir=${CLAUDE_EDITS_DIR:-$HOME/.cache/claude-edits}
noise=${CLAUDE_EDITS_NOISE:-"$HOME/.claude/*:$HOME/.config/*:$HOME/.cache/*:$HOME/Library/*:/tmp/*:/private/tmp/*:/private/var/*"}
max_bytes=1048576
max_rows=200
max_age_days=30
keep_versions=10

IFS=$'\x1f' read -r ev sid f prompt < <(jq -r '[.hook_event_name, .session_id, .tool_input.file_path, ((.prompt // "") | gsub("[\\n\\r\\t\\x1f]"; " ") | .[0:60])] | map(. // "") | join("\u001f")' 2>/dev/null)

if [ "$ev" = UserPromptSubmit ]; then
  [ -n "$sid" ] || exit 0
  mkdir -p "$dir/snapshots/$sid" 2>/dev/null || exit 0
  t=$dir/snapshots/$sid/turns.tsv
  if [ -f "$t" ]; then n=$(($(wc -l <"$t") + 1)); else n=1; fi
  printf '%s\t%s\t%s\n' "$n" "$(date +%s)" "$prompt" >>"$t"
  exit 0
fi

[ -n "$f" ] || exit 0

f0=$f
d=$(cd "$(dirname "$f")" 2>/dev/null && pwd -P) || exit 0
f=$d/$(basename "$f")

root=$(git -C "$d" rev-parse --show-toplevel 2>/dev/null)
if [ -n "$root" ]; then
  kind=git
  target=$root
else
  kind=file
  target=$f
  IFS=: read -ra pats <<<"$noise"
  [ -r "$HOME/.config/claude-edits-ignore" ] && while IFS= read -r p; do
    [ -n "$p" ] && pats+=("${p/#\~/$HOME}")
  done <"$HOME/.config/claude-edits-ignore"
  for p in "${pats[@]}"; do
    # the glob match is intended
    # shellcheck disable=SC2053
    [[ $f == $p || $f0 == $p ]] && exit 0
  done
fi

mkdir -p "$dir/snapshots" 2>/dev/null || exit 0

if [ "$ev" = PreToolUse ]; then
  [ "$kind" = file ] || exit 0
  sd=$dir/snapshots/$sid
  s=$sd/$(printf %s "$f" | shasum | cut -c1-16)
  if [ ! -e "$s/path" ]; then
    if [ -e "$f" ]; then
      [ "$(wc -c <"$f")" -le "$max_bytes" ] || exit 0
      if [ -s "$f" ] && ! grep -Iq . "$f" 2>/dev/null; then exit 0; fi
      mkdir -p "$s" && cp -p "$f" "$s/content" || exit 0
    else
      mkdir -p "$s" && : >"$s/new" || exit 0
    fi
    printf %s "$f" >"$s/path"
  fi
  [ -e "$s/path" ] || exit 0

  # one copy per prompt, taken the first time that prompt touches the file
  turn=0
  [ -f "$sd/turns.tsv" ] && turn=$(wc -l <"$sd/turns.tsv")
  v=$(printf 't%04d' "$turn")
  if [ ! -e "$s/$v" ] && [ ! -e "$s/$v.new" ]; then
    if [ -e "$f" ]; then cp "$f" "$s/$v" 2>/dev/null; else : >"$s/$v.new"; fi
    for x in "$s"/t[0-9]*; do [ -e "$x" ] && echo "${x##*/}"; done | sort |
      awk -v keep="$keep_versions" '{ a[NR] = $0 } END { for (i = 1; i <= NR - keep; i++) print a[i] }' |
      while IFS= read -r old; do rm -f "$s/$old"; done
  fi

  # drop sessions with no activity for 7 days (a copy, a prompt or a new file would keep one alive)
  for sdir in "$dir"/snapshots/*/; do
    [ -d "$sdir" ] || continue
    [ -n "$(find "$sdir" -type f -mtime -7 -print -quit 2>/dev/null)" ] || rm -rf "$sdir"
  done
  exit 0
fi

[ "$ev" = PostToolUse ] || exit 0

reg=$dir/registry.tsv
lock=$dir/.lock
for _ in 1 2 3 4 5 6 7 8 9 10; do
  mkdir "$lock" 2>/dev/null && break
  sleep 0.1
done
trap 'rmdir "$lock" 2>/dev/null' EXIT

touch "$reg"
now=$(date +%s)
tmp=$(mktemp "$dir/reg.XXXXXX") || exit 0
awk -F'\t' -v OFS='\t' -v k="$kind" -v t="$target" -v now="$now" -v sid="$sid" -v cut="$((now - max_age_days * 86400))" '
  $1 == k && $2 == t { print k, t, $3 + 1, now, sid; found = 1; next }
  $4 >= cut { print }
  END { if (!found) print k, t, 1, now, sid }
' "$reg" | sort -t$'\t' -k4,4nr | head -n "$max_rows" >"$tmp" && mv "$tmp" "$reg"
rm -f "$tmp" 2>/dev/null
exit 0
