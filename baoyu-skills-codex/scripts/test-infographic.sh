#!/bin/sh
set -eu

SRC="${1:-./tmp/codex-best-practices.md}"
OUT_DIR="${2:-./tmp/infographic-codex}"

if [ ! -f "$SRC" ]; then
  echo "source markdown not found: $SRC"
  exit 1
fi

if [ -z "${DASHSCOPE_API_KEY:-}" ]; then
  echo "DASHSCOPE_API_KEY is required for the infographic smoke test"
  exit 1
fi

mkdir -p "$OUT_DIR/prompts"

python3 - "$SRC" "$OUT_DIR/prompts/infographic.md" <<'PY'
from pathlib import Path
import re
import sys

src = Path(sys.argv[1])
out = Path(sys.argv[2])
text = src.read_text()

title_match = re.search(r'^title:\s*"(.*)"\s*$', text, re.M)
h1_match = re.search(r'^#\s+(.+)$', text, re.M)
title = (title_match.group(1) if title_match else None) or (h1_match.group(1) if h1_match else "Untitled")

sections = re.findall(r'^##\s+(.+)$', text, re.M)
key_sections = sections[:5]
labels = ", ".join([f'"{s}"' for s in key_sections]) or '"Task clarity", "Planning", "AGENTS.md", "Config", "Skills & automation"'

prompt = f"""Create a professional infographic following these specifications:

## Image Specifications

- Type: Infographic
- Layout: dense-modules
- Style: pop-laboratory
- Aspect Ratio: 16:9
- Language: zh

## Core Principles

- Use a high-density modular infographic with 6 distinct information modules
- Preserve the source meaning faithfully
- Emphasize system thinking, workflow design, and engineering process
- Keep the visual hierarchy extremely clear even with dense information
- Use blueprint-grid precision with bold technical labels

## Layout Guidelines

- Use a dense-modules layout with 6 blocks
- Include one headline module, four concept modules, and one action-summary module
- Every module should contain a concrete heading and 2-4 short supporting lines
- Add arrows, connectors, coordinate markers, and compact metadata details

## Style Guidelines

- Use pop-laboratory aesthetics
- Background should feel like a technical design board
- Use muted teal as the primary block color
- Use fluorescent pink only for emphasis and warnings
- Use lemon-yellow highlight effects on keywords
- Keep typography crisp and diagram-like

## Content

Title: {title}

Main message:
Codex works best when teams turn prompting into a reusable engineering system rather than relying on one-off prompts.

Modules:
1. Clear Task Definition
- Goal
- Context
- Constraints
- Done when

2. Plan Before Coding
- Use plan mode for multi-step work
- Clarify ambiguity before implementation
- Avoid locking the wrong structure in early

3. Move Rules Into AGENTS.md
- Make stable rules reusable
- Keep repo guidance short and precise
- Let local rules override global ones

4. Use Config For Consistency
- Put defaults in config
- Reduce session randomness
- Control approval and sandbox deliberately

5. Validate, Review, And Prove The Work
- Add tests
- Run checks
- Review diffs
- Treat verification as part of the task

6. Skills And Automations
- Skills define the method
- Automations define the cadence
- Stabilize workflows before scheduling them

Text labels (in zh):
{labels}
"""

out.write_text(prompt)
PY

OUT_IMAGE="$OUT_DIR/infographic.png"

echo "generating infographic from $SRC"
bun skills/baoyu-imagine/scripts/main.ts \
  --promptfiles "$OUT_DIR/prompts/infographic.md" \
  --image "$OUT_IMAGE" \
  --provider dashscope \
  --model qwen-image-2.0-pro \
  --ar 16:9

echo "generated: $OUT_IMAGE"
ls -lh "$OUT_IMAGE"
