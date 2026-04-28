#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_DIR="$ROOT_DIR/skills/baoyu-danger-x-to-markdown"
SCRIPTS_DIR="$SKILL_DIR/scripts"
URL="${1:-https://x.com/OpenAI/status/1907258749101697479}"
OUT_DIR="${2:-$ROOT_DIR/tmp/x-to-markdown-codex}"
STATE_DIR="$OUT_DIR/state"
JSON_PATH="$OUT_DIR/result.json"

mkdir -p "$OUT_DIR" "$STATE_DIR"

if [[ ! -d "$SCRIPTS_DIR/node_modules" ]]; then
  (cd "$SCRIPTS_DIR" && bun install)
fi

cat > "$STATE_DIR/consent.json" <<'JSON'
{
  "version": 1,
  "accepted": true,
  "acceptedAt": "2026-04-16T00:00:00.000Z",
  "disclaimerVersion": "1.0"
}
JSON

bun test "$SCRIPTS_DIR/markdown.test.ts"

X_DATA_DIR="$STATE_DIR" bun "$SCRIPTS_DIR/main.ts" "$URL" -o "$OUT_DIR" --json > "$JSON_PATH"

python3 - "$JSON_PATH" <<'PY2'
from pathlib import Path
import json
import sys

obj = json.load(open(sys.argv[1]))
md = Path(obj['markdownPath'])
if not md.exists():
    raise SystemExit(f"markdown not found: {md}")
text = md.read_text()
if 'url:' not in text:
    raise SystemExit('frontmatter url missing')
print(md)
PY2

printf 'result json: %s\n' "$JSON_PATH"
cat "$JSON_PATH"
