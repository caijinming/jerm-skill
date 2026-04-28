#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="${1:-$ROOT_DIR/tmp/codex-best-practices.md}"
SKILL_DIR="$ROOT_DIR/skills/baoyu-post-to-x"
SCRIPTS_DIR="$SKILL_DIR/scripts"
OUT_DIR="${2:-$ROOT_DIR/tmp/post-to-x-codex}"
PERM_LOG="$OUT_DIR/check-paste-permissions.log"
HTML_JSON="$OUT_DIR/md-to-html.json"
WORK_MD="$OUT_DIR/x-source.md"
HTML_PATH="$OUT_DIR/x-article.html"

if [[ ! -f "$SRC" ]]; then
  echo "source markdown not found: $SRC" >&2
  exit 1
fi

mkdir -p "$OUT_DIR"

python3 - "$SRC" "$WORK_MD" <<'PY'
from pathlib import Path
import re
import sys

src = Path(sys.argv[1]).read_text()
clean = re.sub(r'!\[([^\]]*)\]\((https?://[^)]+)\)', r'\1', src)
clean = re.sub(r'^coverImage:\s*"https?://[^"]+"\s*\n', '', clean, flags=re.M)
Path(sys.argv[2]).write_text(clean)
PY

if [[ ! -d "$SCRIPTS_DIR/node_modules" ]]; then
  (cd "$SCRIPTS_DIR" && bun install)
fi

bun test "$SCRIPTS_DIR/x-utils.test.ts"

set +e
bun "$SCRIPTS_DIR/check-paste-permissions.ts" > "$PERM_LOG" 2>&1
PERM_STATUS=$?
set -e

bun "$SCRIPTS_DIR/md-to-html.ts" "$WORK_MD" > "$HTML_JSON"

python3 - "$HTML_JSON" "$HTML_PATH" <<'PY'
from pathlib import Path
import json
import sys

data = json.load(open(sys.argv[1]))
Path(sys.argv[2]).write_text(data["html"])
PY

if [[ ! -f "$HTML_PATH" ]]; then
  echo "x-ready html not found: $HTML_PATH" >&2
  exit 1
fi

echo "Permission check exit: $PERM_STATUS"
echo "Permission log: $PERM_LOG"
echo "HTML JSON: $HTML_JSON"
echo "HTML Path: $HTML_PATH"
ls -lh "$HTML_PATH" "$HTML_JSON" "$PERM_LOG"
