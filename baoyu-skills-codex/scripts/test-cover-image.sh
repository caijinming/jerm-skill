#!/bin/sh
set -eu

SRC="${1:-./tmp/codex-best-practices.md}"
OUT_DIR="${2:-./tmp/cover-image-smoke}"

if [ ! -f "$SRC" ]; then
  echo "source markdown not found: $SRC"
  exit 1
fi

if [ -z "${DASHSCOPE_API_KEY:-}" ]; then
  echo "DASHSCOPE_API_KEY is required for the cover-image smoke test"
  exit 1
fi

mkdir -p "$OUT_DIR/prompts"

python3 - "$SRC" "$OUT_DIR/prompts/cover.md" <<'PY'
from pathlib import Path
import re
import sys

src = Path(sys.argv[1])
out = Path(sys.argv[2])
text = src.read_text()

title_match = re.search(r'^title:\s*"(.*)"\s*$', text, re.M)
h1_match = re.search(r'^#\s+(.+)$', text, re.M)
title = (title_match.group(1) if title_match else None) or (h1_match.group(1) if h1_match else "Untitled")

body = text.split('---\n', 2)[-1] if text.startswith('---\n') else text
paragraphs = [p.strip().replace("\n", " ") for p in body.split("\n\n") if p.strip() and not p.strip().startswith("#")]
summary = " ".join(paragraphs[:2])[:240].strip()

prompt = f"""---
type: cover
palette: cool
rendering: flat-vector
---

# Content Context
Article title: {title}
Content summary: {summary}
Keywords: Codex, workflow, AGENTS.md, automation, MCP, prompt, engineering

# Visual Design
Cover theme: codex workflow system
Type: conceptual
Palette: cool
Rendering: flat-vector
Font: clean
Text level: title-only
Mood: balanced
Aspect ratio: 16:9
Language: zh

# Text Elements
Title: {title}

# Composition
Type composition:
- conceptual cover with a central systems diagram metaphor

Visual composition:
- Main visual: a modular workflow system built from connected panels, nodes, and flowing paths
- Layout: strong focal graphic in center-left with spacious right-side title area
- Decorative: subtle code blocks, arrows, and orchestration lines

Color scheme: deep engineering blue background, cyan and teal accents, soft off-white text
Color constraint: Do not display any color names, hex codes, or palette labels as visible text in the image.
Rendering notes: clean flat-vector illustration, crisp geometric shapes, minimal texture, precise edges
Type notes: abstract conceptual system image rather than a literal app screenshot
Palette notes: technical, modern, editorial, calm confidence
"""

out.write_text(prompt)
PY

OUT_IMAGE="$OUT_DIR/cover.png"

echo "generating cover from $SRC"
bun skills/baoyu-imagine/scripts/main.ts \
  --promptfiles "$OUT_DIR/prompts/cover.md" \
  --image "$OUT_IMAGE" \
  --provider dashscope \
  --model qwen-image-2.0-pro \
  --ar 16:9

echo "generated: $OUT_IMAGE"
ls -lh "$OUT_IMAGE"
