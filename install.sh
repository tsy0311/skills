#!/usr/bin/env bash
# Install the vendored ECC skills, agents and commands into ~/.claude so that
# Claude Code can use them in every project.
#
#   ./install.sh                     # symlink everything (skills, agents, commands)
#   ./install.sh tdd-workflow seo    # only these skills (agents/commands untouched)
#   ./install.sh --copy              # copy instead of symlink (no dependency on this checkout)
#   ./install.sh --rules python      # also install rules/common + rules/python
#   ./install.sh --uninstall         # remove everything this script installed
#
# Existing files in ~/.claude that this script did not create are never overwritten.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${CLAUDE_HOME:-$HOME/.claude}"
MODE=link; UNINSTALL=0; RULES=(); PICK=()

while [ $# -gt 0 ]; do
  case "$1" in
    --copy) MODE=copy ;;
    --uninstall) UNINSTALL=1 ;;
    --rules) shift; RULES+=("${1:?--rules needs a language, e.g. python}") ;;
    -h|--help) sed -n '2,11p' "$0"; exit 0 ;;
    -*) echo "unknown option: $1" >&2; exit 1 ;;
    *) PICK+=("$1") ;;
  esac
  shift
done

MARK=".ecc-installed"   # marker so uninstall only touches what we created
installed=0; skipped=0

place() { # place <source> <target>
  local src="$1" dst="$2"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if [ -L "$dst" ] && [[ "$(readlink "$dst")" == "$SRC"/* ]]; then rm "$dst"
    elif [ -e "$dst/$MARK" ] || grep -qs "^$dst\$" "$DEST/$MARK"; then rm -rf "$dst"
    else echo "skip (exists, not ours): $dst"; skipped=$((skipped+1)); return; fi
  fi
  if [ "$MODE" = link ]; then ln -s "$src" "$dst"; else cp -R "$src" "$dst"; fi
  echo "$dst" >> "$DEST/$MARK"
  installed=$((installed+1))
}

if [ "$UNINSTALL" = 1 ]; then
  [ -f "$DEST/$MARK" ] || { echo "nothing to uninstall"; exit 0; }
  sort -u "$DEST/$MARK" | while read -r p; do [ -n "$p" ] && rm -rf "$p"; done
  rm -f "$DEST/$MARK"; echo "removed ECC items from $DEST"; exit 0
fi

mkdir -p "$DEST/skills" "$DEST/agents" "$DEST/commands"
touch "$DEST/$MARK"

if [ ${#PICK[@]} -gt 0 ]; then
  for s in "${PICK[@]}"; do
    [ -d "$SRC/skills/$s" ] || { echo "no such skill: $s (see CATALOG.md)" >&2; exit 1; }
    place "$SRC/skills/$s" "$DEST/skills/$s"
  done
else
  for d in "$SRC"/skills/*/;   do d="${d%/}"; place "$d" "$DEST/skills/$(basename "$d")"; done
  for f in "$SRC"/agents/*.md;   do place "$f" "$DEST/agents/$(basename "$f")"; done
  for f in "$SRC"/commands/*.md; do place "$f" "$DEST/commands/$(basename "$f")"; done
fi

for lang in "${RULES[@]}"; do
  [ -d "$SRC/rules/$lang" ] || { echo "no rules for: $lang (have: $(ls "$SRC/rules" | tr '\n' ' '))" >&2; exit 1; }
  mkdir -p "$DEST/rules"
  for r in common "$lang"; do place "$SRC/rules/$r" "$DEST/rules/$r"; done
done

sort -u -o "$DEST/$MARK" "$DEST/$MARK"
echo "installed $installed item(s) into $DEST ($MODE), skipped $skipped. Restart Claude Code to load them."
