#!/bin/sh
set -eu

SRC="${1:-./tmp/codex-best-practices.md}"
OUT_DIR="${2:-./tmp/slide-deck-codex}"

if [ ! -f "$SRC" ]; then
  echo "source markdown not found: $SRC"
  exit 1
fi

if [ -z "${DASHSCOPE_API_KEY:-}" ]; then
  echo "DASHSCOPE_API_KEY is required for the slide-deck smoke test"
  exit 1
fi

if [ ! -d node_modules ]; then
  echo "installing repo dependencies"
  npm install
fi

mkdir -p "$OUT_DIR/prompts"

python3 - "$SRC" "$OUT_DIR" <<'PY'
from pathlib import Path
import re
import sys

src = Path(sys.argv[1])
out_dir = Path(sys.argv[2])
text = src.read_text()

title_match = re.search(r'^title:\s*"(.*)"\s*$', text, re.M)
h1_match = re.search(r'^#\s+(.+)$', text, re.M)
title = (title_match.group(1) if title_match else None) or (h1_match.group(1) if h1_match else "Untitled")
sections = re.findall(r'^##\s+(.+)$', text, re.M)
sec1 = sections[0] if len(sections) > 0 else "第一步先把任务讲清楚"
sec2 = sections[1] if len(sections) > 1 else "复杂任务先规划，再进入实现"

outline = f"""# Slide Deck Outline

**Topic**: {title}
**Style**: blueprint
**Dimensions**: grid + cool + technical + balanced
**Audience**: general
**Language**: zh
**Slide Count**: 3 slides

---

<STYLE_INSTRUCTIONS>
Design Aesthetic: Clean blueprint-style technical presentation with precise grids, analytical diagrams, and restrained engineering color accents.
Background:
  Texture: subtle grid overlay
  Base Color: blueprint off-white
Typography:
  Headlines: bold clean sans-serif with technical clarity
  Body: readable editorial text with restrained hierarchy
Color Palette:
  Primary Text: Deep Slate (#334155)
  Background: Blueprint Paper (#FAF8F5)
  Accent 1: Engineering Blue (#2563EB)
  Accent 2: Light Blue (#BFDBFE)
Visual Elements:
  - straight connectors
  - grid-aligned content boxes
  - clean schematic icons
Density Guidelines:
  - 2-3 key points per slide
  - readable but information-rich
Style Rules:
  Do: keep geometry precise, use grid alignment
  Don't: use organic doodles or decorative clutter
</STYLE_INSTRUCTIONS>

---

## Slide 1 of 3
**Type**: Cover
**Filename**: 01-slide-cover.png
Headline: {title}
Sub-headline: 从一次性提示词到可复用工作流
Visual: central modular system diagram with blueprint composition
Layout: title-hero

---

## Slide 2 of 3
**Type**: Content
**Filename**: 02-slide-task-clarity.png
Headline: {sec1}
Sub-headline: 先定义边界，再让系统执行
Body:
- Goal
- Context
- Constraints
- Done when
Visual: four-box framework with arrows and engineering markers
Layout: grid

---

## Slide 3 of 3
**Type**: Back Cover
**Filename**: 03-slide-back-cover.png
Headline: {sec2}
Body: 复杂任务先规划，再进入实现
Visual: closing summary slide with roadmap metaphor and clean CTA
Layout: minimal-closing
"""

prompts = {
    "01-slide-cover.md": f"""Create a 16:9 presentation slide image.

Style: blueprint
Language: zh
Goal:
- premium technical cover slide
- self-explanatory without presenter narration

Text:
- {title}
- 从一次性提示词到可复用工作流

Visual:
- blueprint grid background
- central modular workflow architecture
- precise technical lines and diagram boxes
""",
    "02-slide-task-clarity.md": f"""Create a 16:9 presentation slide image.

Style: blueprint
Language: zh

Slide title:
{sec1}

Content:
- Goal
- Context
- Constraints
- Done when

Visual:
- four-part framework
- technical schematic arrows
- clean information hierarchy
""",
    "03-slide-back-cover.md": f"""Create a 16:9 presentation slide image.

Style: blueprint
Language: zh

Slide title:
{sec2}

Content:
- 复杂任务先规划
- 先把问题定义对
- 再进入实现

Visual:
- closing roadmap metaphor
- clean final takeaway slide
- engineering blue accents
""",
}

(out_dir / "outline.md").write_text(outline)
prompt_dir = out_dir / "prompts"
prompt_dir.mkdir(parents=True, exist_ok=True)
for name, content in prompts.items():
    (prompt_dir / name).write_text(content)
PY

generate_slide() {
  prompt_file="$1"
  image_file="$2"
  if [ -f "$image_file" ]; then
    echo "skip existing: $image_file"
    return 0
  fi
  bun skills/baoyu-imagine/scripts/main.ts \
    --promptfiles "$prompt_file" \
    --image "$image_file" \
    --provider dashscope \
    --model qwen-image-2.0-pro \
    --ar 16:9
}

echo "generating slide deck from $SRC"
generate_slide "$OUT_DIR/prompts/01-slide-cover.md" "$OUT_DIR/01-slide-cover.png"
sleep 12
generate_slide "$OUT_DIR/prompts/02-slide-task-clarity.md" "$OUT_DIR/02-slide-task-clarity.png"
sleep 12
generate_slide "$OUT_DIR/prompts/03-slide-back-cover.md" "$OUT_DIR/03-slide-back-cover.png"

bun skills/baoyu-slide-deck/scripts/merge-to-pptx.ts "$OUT_DIR"
bun skills/baoyu-slide-deck/scripts/merge-to-pdf.ts "$OUT_DIR"

echo "generated deck artifacts:"
ls -lh "$OUT_DIR"
