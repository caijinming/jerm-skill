#!/bin/sh
set -eu

SRC="${1:-./tmp/codex-best-practices.md}"
OUT_DIR="${2:-./tmp/image-cards-codex}"

if [ ! -f "$SRC" ]; then
  echo "source markdown not found: $SRC"
  exit 1
fi

if [ -z "${DASHSCOPE_API_KEY:-}" ]; then
  echo "DASHSCOPE_API_KEY is required for the image-cards smoke test"
  exit 1
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
section_a = sections[0] if len(sections) > 0 else "第一步先把任务讲清楚"
section_b = sections[1] if len(sections) > 1 else "复杂任务先规划，再进入实现"

cards = {
    "01-cover-codex.md": f"""Create a Xiaohongshu style image card.

Style: notion
Layout: sparse
Aspect ratio: 3:4
Language: zh

Goal:
- Strong cover image with high stop-scroll power
- Clear handwritten infographic feel

Text:
- Title: {title}
- Subtitle: 把一次性提示词变成可复用工作流

Visual:
- clean white background
- notion style line art
- a central modular workflow diagram
- arrows, boxes, and small hand-drawn marks
""",
    "02-content-codex.md": f"""Create a Xiaohongshu style image card.

Style: notion
Layout: dense
Aspect ratio: 3:4
Language: zh

Card topic:
{section_a}

Text content:
- Goal
- Context
- Constraints
- Done when

Visual:
- dense notion-style knowledge card
- four content zones
- hand-drawn boxes, underlines, and icons
- save-worthy study-note feel
""",
    "03-ending-codex.md": f"""Create a Xiaohongshu style image card.

Style: notion
Layout: balanced
Aspect ratio: 3:4
Language: zh

Card topic:
{section_b}

Text content:
- 复杂任务先规划
- 先把问题定义对
- 再进入实现
- 技能和自动化负责复用

Visual:
- balanced educational summary card
- simple arrows and sticky-note blocks
- clean wrap-up page with CTA feel
""",
}

prompt_dir = out_dir / "prompts"
prompt_dir.mkdir(parents=True, exist_ok=True)
for name, content in cards.items():
    (prompt_dir / name).write_text(content)
PY

generate_card() {
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
    --ar 3:4
}

echo "generating image card series from $SRC"
generate_card "$OUT_DIR/prompts/01-cover-codex.md" "$OUT_DIR/01-cover-codex.png"
sleep 8
generate_card "$OUT_DIR/prompts/02-content-codex.md" "$OUT_DIR/02-content-codex.png"
sleep 8
generate_card "$OUT_DIR/prompts/03-ending-codex.md" "$OUT_DIR/03-ending-codex.png"

echo "generated cards:"
ls -lh "$OUT_DIR"/*.png
