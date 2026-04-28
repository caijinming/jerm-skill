#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="${1:-$ROOT_DIR/tmp/codex-best-practices.md}"
THEME="${2:-modern}"
SKILL_DIR="$ROOT_DIR/skills/baoyu-markdown-to-html"
SCRIPTS_DIR="$SKILL_DIR/scripts"
OUT_HTML="${SRC%.md}.html"

if [[ ! -f "$SRC" ]]; then
  echo "source markdown not found: $SRC" >&2
  exit 1
fi

if [[ ! -d "$SCRIPTS_DIR/node_modules" ]]; then
  (cd "$SCRIPTS_DIR" && bun install)
fi

bun "$SCRIPTS_DIR/main.ts" "$SRC" --theme "$THEME"

if [[ ! -f "$OUT_HTML" ]]; then
  echo "expected output html not found: $OUT_HTML" >&2
  exit 1
fi

echo "HTML: $OUT_HTML"
ls -lh "$OUT_HTML"
