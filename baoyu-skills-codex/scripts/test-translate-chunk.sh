#!/bin/sh
set -eu

SRC="${1:-./tmp/sample.md}"
OUT_DIR="${2:-./tmp/translate-check}"

mkdir -p "$(dirname "$SRC")" "$OUT_DIR"

if [ ! -f "$SRC" ]; then
  cat <<'EOF_SAMPLE' > "$SRC"
---
title: Sample Article
---

# Intro

This is a small markdown file used to validate the baoyu-translate chunking flow in Codex.

## Body

The goal is not to prove translation quality yet. The goal is to prove that the local helper script works, that the skill can reference it, and that the output structure is understandable.
EOF_SAMPLE
fi

if command -v bun >/dev/null 2>&1; then
  BUN_X="bun"
elif command -v npx >/dev/null 2>&1; then
  BUN_X="npx -y bun"
else
  echo "Install bun first: brew install oven-sh/bun/bun"
  exit 1
fi

TRANSLATE_DIR="skills/baoyu-translate/scripts"
if [ ! -d "$TRANSLATE_DIR/node_modules" ]; then
  echo "installing dependencies in $TRANSLATE_DIR"
  (cd "$TRANSLATE_DIR" && $BUN_X install)
fi

CMD="$BUN_X skills/baoyu-translate/scripts/main.ts \"$SRC\" --output-dir \"$OUT_DIR\" --max-words 60"

echo "running: $CMD"
sh -c "$CMD"

echo "chunks:"
find "$OUT_DIR" -maxdepth 2 -type f | sort
