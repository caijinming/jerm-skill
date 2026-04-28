#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VIDEO_URL="${1:-https://www.youtube.com/watch?v=dQw4w9WgXcQ}"
OUT_DIR="${2:-$ROOT_DIR/tmp/youtube-transcript-codex}"
SKILL_DIR="$ROOT_DIR/skills/baoyu-youtube-transcript"
USER_PY_BIN="$HOME/Library/Python/3.9/bin"

if [[ -d "$USER_PY_BIN" ]]; then
  export PATH="$USER_PY_BIN:$PATH"
fi

bun test "$SKILL_DIR/scripts/main.test.ts"

mkdir -p "$OUT_DIR"

bun "$SKILL_DIR/scripts/main.ts" "$VIDEO_URL" \
  --languages en \
  --chapters \
  --output-dir "$OUT_DIR"

TRANSCRIPT_FILE="$(find "$OUT_DIR" -name transcript.md | head -n 1)"
META_FILE="$(find "$OUT_DIR" -name meta.json | head -n 1)"
COVER_FILE="$(find "$OUT_DIR" -path '*/imgs/cover.jpg' | head -n 1)"

if [[ -z "$TRANSCRIPT_FILE" || ! -f "$TRANSCRIPT_FILE" ]]; then
  echo "transcript file not found under $OUT_DIR" >&2
  exit 1
fi

if [[ -z "$META_FILE" || ! -f "$META_FILE" ]]; then
  echo "meta file not found under $OUT_DIR" >&2
  exit 1
fi

if [[ -z "$COVER_FILE" || ! -f "$COVER_FILE" ]]; then
  echo "cover image not found under $OUT_DIR" >&2
  exit 1
fi

echo "Transcript: $TRANSCRIPT_FILE"
echo "Meta: $META_FILE"
echo "Cover: $COVER_FILE"
ls -lh "$TRANSCRIPT_FILE" "$META_FILE" "$COVER_FILE"
