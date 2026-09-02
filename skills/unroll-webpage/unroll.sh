#!/usr/bin/env bash
# Bootstrap wrapper for the unroll-webpage skill.
# Ensures a per-skill venv exists with deps installed, then runs convert.py.
#
# Usage: unroll.sh <url> [--out PATH]

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV="$SKILL_DIR/.venv"
STAMP="$VENV/.deps-installed"
REQS="$SKILL_DIR/requirements.txt"

if [ ! -d "$VENV" ]; then
  echo "Creating venv at $VENV ..." >&2
  python3 -m venv "$VENV"
fi

if [ ! -f "$STAMP" ] || [ "$REQS" -nt "$STAMP" ]; then
  echo "Installing dependencies ..." >&2
  "$VENV/bin/pip" install -q --upgrade pip
  "$VENV/bin/pip" install -q -r "$REQS"
  touch "$STAMP"
fi

exec "$VENV/bin/python" "$SKILL_DIR/convert.py" "$@"
