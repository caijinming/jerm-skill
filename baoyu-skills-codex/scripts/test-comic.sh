#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_INPUT="${1:-$ROOT_DIR/tmp/codex-best-practices.md}"
OUTPUT_DIR="${2:-$ROOT_DIR/tmp/comic-codex}"
SKILL_DIR="$ROOT_DIR/skills/baoyu-comic"
IMAGINE_DIR="$ROOT_DIR/skills/baoyu-imagine"
SLUG="codex-four-panel"
PROMPTS_DIR="$OUTPUT_DIR/prompts"
PROMPT_FILE="$PROMPTS_DIR/01-page-$SLUG.md"
IMAGE_FILE="$OUTPUT_DIR/01-page-$SLUG.png"
PDF_FILE="$OUTPUT_DIR/$SLUG.pdf"
STORYBOARD_FILE="$OUTPUT_DIR/storyboard.md"

if [[ ! -f "$SOURCE_INPUT" ]]; then
  echo "Source file not found: $SOURCE_INPUT" >&2
  exit 1
fi

if [[ -z "${DASHSCOPE_API_KEY:-}" ]]; then
  echo "DASHSCOPE_API_KEY is required for live comic rendering." >&2
  exit 1
fi

mkdir -p "$PROMPTS_DIR"

TITLE="$(sed -n 's/^title: *//p' "$SOURCE_INPUT" | head -n1 | sed 's/^"//; s/"$//')"
if [[ -z "$TITLE" ]]; then
  TITLE="Codex Best Practices"
fi

cat > "$STORYBOARD_FILE" <<EOF
---
title: "Codex Best Practices Four-Panel Comic"
topic: "$TITLE"
narrative_approach: "concept-focused"
recommended_style: "minimalist"
recommended_layout: "four-panel"
aspect_ratio: "4:3"
language: "zh"
page_count: 1
generated: "$(date '+%Y-%m-%d %H:%M')"
---

# Codex Best Practices Four-Panel Comic

## Page 1 / 1

**Filename**: 01-page-$SLUG.png
**Layout**: four-panel
**Core Message**: 把一次性提示词变成可复用工作流，Codex 才真正开始提效。

### Panel 1
- Role: 起 Setup
- Scene: 一名开发者面对一长串临时 prompt，桌上便签凌乱。
- Text: “每次都从零写提示词，好累。”

### Panel 2
- Role: 承 Development
- Scene: 屏幕上出现 skill、脚本、固定测试入口，流程开始被整理。
- Text: “先把常见任务固化成 workflow。”

### Panel 3
- Role: 转 Turn
- Scene: 同一个开发者按下运行按钮，自动抓文、翻译、出图、产出 deck，橙色高亮聚焦在“复用”。
- Text: “关键不是更长的 prompt，而是可重复执行。”

### Panel 4
- Role: 合 Conclusion
- Scene: 桌面变整洁，输出文件整齐排开，角色露出轻松表情。
- Text: “把流程做成 skill，效率才会稳定提升。”
EOF

cat > "$PROMPT_FILE" <<EOF
A minimalist, clean line art digital comic strip in a strict four-panel grid layout (2x2), landscape 4:3 page, simplified cartoon illustration with clear black outlines and a minimal color palette of black, white, and spot orange #FF6B35 for key concepts.

Create one single-page educational comic in Chinese about this idea: transforming one-off prompts into reusable Codex workflows.

Follow strict 起承转合 structure:
- Top Left panel (起): a developer sits at a cluttered desk covered with messy prompt notes, looking tired. Dialogue bubble: “每次都从零写提示词，好累。”
- Top Right panel (承): the screen now shows organized skills, scripts, and test steps, the developer starts structuring the process. Dialogue bubble: “先把常见任务固化成 workflow。”
- Bottom Left panel (转): the most important panel, emphasize the twist with orange accent around the word “复用”; the developer triggers a repeatable pipeline that outputs markdown, translation, images, and slides. Dialogue bubble: “关键不是更长的 prompt，而是可重复执行。”
- Bottom Right panel (合): the workspace is tidy, files are neatly arranged, and the developer looks relaxed and confident. Dialogue bubble: “把流程做成 skill，效率才会稳定提升。”

Style rules:
- Exactly 4 equal panels in a strict 2x2 grid
- Simplified stick-figure-like characters with minimal props
- Mostly black and white, orange accent only on key concepts
- Very little text, 1 short line per panel
- Clean white gutters between panels
- Modern product-design / coding context
- Hand-drawn Chinese text style inside speech bubbles
EOF

if [[ ! -f "$IMAGE_FILE" ]]; then
  bun "$IMAGINE_DIR/scripts/main.ts" \
    --promptfiles "$PROMPT_FILE" \
    --image "$IMAGE_FILE" \
    --provider dashscope \
    --model qwen-image-2.0-pro \
    --ar 4:3
fi

bun "$SKILL_DIR/scripts/merge-to-pdf.ts" "$OUTPUT_DIR" --output "$PDF_FILE"

echo "Storyboard: $STORYBOARD_FILE"
echo "Prompt: $PROMPT_FILE"
echo "Image: $IMAGE_FILE"
echo "PDF: $PDF_FILE"
