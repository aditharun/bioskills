#!/usr/bin/env bash
# Install bioskills into Claude Code.
# Idempotent and safe — refuses to clobber existing non-symlink files.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${CLAUDE_HOME:-$HOME/.claude}"
SKILLS_DIR="$CLAUDE_DIR/skills"
SETTINGS="$CLAUDE_DIR/settings.json"

mkdir -p "$SKILLS_DIR"

# --- 1. Symlink the nct skill --------------------------------------------------
SKILL_LINK="$SKILLS_DIR/nct"
SKILL_TARGET="$REPO_DIR/skills/nct"

if [ -L "$SKILL_LINK" ]; then
  CURRENT=$(readlink "$SKILL_LINK")
  if [ "$CURRENT" = "$SKILL_TARGET" ]; then
    echo "✓ nct skill already linked to this repo"
  else
    echo "✗ $SKILL_LINK is a symlink pointing elsewhere ($CURRENT)."
    echo "  Remove it manually if you want to relink to this repo."
    exit 1
  fi
elif [ -e "$SKILL_LINK" ]; then
  echo "✗ $SKILL_LINK already exists and is not a symlink."
  echo "  Back it up and remove it, then re-run this script."
  exit 1
else
  ln -s "$SKILL_TARGET" "$SKILL_LINK"
  echo "✓ linked $SKILL_LINK → $SKILL_TARGET"
fi

# --- 2. Merge the hook into settings.json -------------------------------------
HOOK_SNIPPET="$REPO_DIR/hooks/nct-hook-snippet.json"

if ! command -v jq >/dev/null 2>&1; then
  echo "✗ jq is required to merge the hook. Install with: brew install jq"
  exit 1
fi

if [ ! -f "$SETTINGS" ]; then
  echo "{}" > "$SETTINGS"
fi

# Detect existing UserPromptSubmit hook with our command signature.
EXISTING=$(jq '[.hooks.UserPromptSubmit // [] | .[].hooks[]? | select(.command? | type == "string" and contains("clinicaltrials.gov/study"))] | length' "$SETTINGS")

if [ "$EXISTING" -gt 0 ]; then
  echo "✓ nct hook already present in $SETTINGS"
else
  TMP=$(mktemp)
  # Strip the _comment key from the snippet, then merge hooks arrays.
  jq --slurpfile add <(jq 'del(._comment)' "$HOOK_SNIPPET") '
    .hooks = (.hooks // {}) |
    .hooks.UserPromptSubmit = ((.hooks.UserPromptSubmit // []) + ($add[0].hooks.UserPromptSubmit))
  ' "$SETTINGS" > "$TMP" && mv "$TMP" "$SETTINGS"
  echo "✓ merged nct hook into $SETTINGS"
fi

echo
echo "Done. Open /hooks in Claude Code (or restart) to activate the hook."
