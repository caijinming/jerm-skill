#!/bin/sh
set -eu

URL="${1:-https://example.com}"
OUT="${2:-./tmp/example.md}"
OUT_DIR="$(dirname "$OUT")"
mkdir -p "$OUT_DIR"

if command -v bun >/dev/null 2>&1; then
  BUN_X="bun"
elif command -v npx >/dev/null 2>&1; then
  BUN_X="npx -y bun"
else
  echo "Install bun first: brew install oven-sh/bun/bun"
  exit 1
fi

FETCH_DIR="skills/baoyu-url-to-markdown/scripts/vendor/baoyu-fetch"
if [ ! -d "$FETCH_DIR/node_modules" ]; then
  echo "installing dependencies in $FETCH_DIR"
  (cd "$FETCH_DIR" && $BUN_X install)
fi

CMD="$BUN_X skills/baoyu-url-to-markdown/scripts/vendor/baoyu-fetch/src/cli.ts \"$URL\" --output \"$OUT\""

echo "running: $CMD"
sh -c "$CMD"

echo "saved: $OUT"
echo "preview:"
sed -n '1,40p' "$OUT"
