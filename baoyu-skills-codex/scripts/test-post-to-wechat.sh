#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="${1:-$ROOT_DIR/tmp/codex-best-practices.md}"
THEME="${2:-modern}"
SKILL_DIR="$ROOT_DIR/skills/baoyu-post-to-wechat"
SCRIPTS_DIR="$SKILL_DIR/scripts"
OUT_DIR="${3:-$ROOT_DIR/tmp/post-to-wechat-codex}"
PERM_LOG="$OUT_DIR/check-permissions.log"
HTML_JSON="$OUT_DIR/md-to-wechat.json"

if [[ ! -f "$SRC" ]]; then
  echo "source markdown not found: $SRC" >&2
  exit 1
fi

mkdir -p "$OUT_DIR"

if [[ ! -d "$SCRIPTS_DIR/node_modules" ]]; then
  (cd "$SCRIPTS_DIR" && bun install)
fi

bun test "$SCRIPTS_DIR/wechat-extend-config.test.ts"

set +e
bun "$SCRIPTS_DIR/check-permissions.ts" > "$PERM_LOG" 2>&1
PERM_STATUS=$?
set -e

bun "$SCRIPTS_DIR/md-to-wechat.ts" "$SRC" --theme "$THEME" > "$HTML_JSON"

HTML_PATH="$(python3 -c "import json; print(json.load(open('$HTML_JSON'))['htmlPath'])")"

if [[ ! -f "$HTML_PATH" ]]; then
  echo "wechat-ready html not found: $HTML_PATH" >&2
  exit 1
fi

echo "Permission check exit: $PERM_STATUS"
echo "Permission log: $PERM_LOG"
echo "HTML JSON: $HTML_JSON"
echo "HTML Path: $HTML_PATH"
ls -lh "$HTML_PATH" "$HTML_JSON" "$PERM_LOG"
