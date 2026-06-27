#!/usr/bin/env bash
#
# Symlink every skill in this repository into the Claude skills directory.
# A "skill" is any top-level directory that contains a SKILL.md.
#
# Usage:
#   ./install.sh           link all skills
#   ./install.sh --dry-run show what would happen, change nothing

set -euo pipefail

dry_run=false
case "${1:-}" in
  --dry-run) dry_run=true ;;
  "") ;;
  *) echo "usage: $0 [--dry-run]" >&2; exit 2 ;;
esac

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
config_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
skills_dir="$config_dir/skills"

run() {
  if $dry_run; then
    echo "  would: $*"
  else
    "$@"
  fi
}

$dry_run || mkdir -p "$skills_dir"

found=false
for skill_path in "$repo_dir"/skills/*/; do
  [ -f "${skill_path}SKILL.md" ] || continue
  found=true

  name="$(basename "$skill_path")"
  src="${skill_path%/}"
  target="$skills_dir/$name"

  if [ -L "$target" ]; then
    if [ "$(readlink "$target")" = "$src" ]; then
      echo "already linked: $name"
      continue
    fi
    run rm "$target"
    run ln -s "$src" "$target"
    echo "relinked: $name"
  elif [ -e "$target" ]; then
    echo "skipped (not a symlink, won't clobber): $target" >&2
  else
    run ln -s "$src" "$target"
    echo "linked: $name"
  fi
done

$found || { echo "no skills found in $repo_dir" >&2; exit 1; }
