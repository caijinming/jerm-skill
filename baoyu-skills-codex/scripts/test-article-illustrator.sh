#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="${1:-$ROOT_DIR/tmp/codex-best-practices.md}"
OUT_DIR="${2:-$ROOT_DIR/tmp/article-illustrator-codex}"
IMAGINE_DIR="$ROOT_DIR/skills/baoyu-imagine"
PROMPTS_DIR="$OUT_DIR/prompts"

if [[ ! -f "$SRC" ]]; then
  echo "source markdown not found: $SRC" >&2
  exit 1
fi

if [[ -z "${DASHSCOPE_API_KEY:-}" ]]; then
  echo "DASHSCOPE_API_KEY is required for the article-illustrator smoke test" >&2
  exit 1
fi

mkdir -p "$PROMPTS_DIR"

cat > "$OUT_DIR/outline.md" <<'EOF'
---
type: mixed
density: balanced-light
style: blueprint
palette: default
image_count: 2
generated_for: codex-best-practices
---

# Article Illustration Outline

## Illustration 1
**Position**: opening section
**Purpose**: explain why reusable workflow matters more than one-off prompting
**Type**: framework
**Visual Content**: a modular codex workflow system linking prompt, skill, script, validation, and reusable outputs
**Filename**: 01-framework-codex-workflow.png

## Illustration 2
**Position**: middle section about execution and reuse
**Purpose**: show the operational loop from article input to stable output assets
**Type**: flowchart
**Visual Content**: article ingestion, analysis, prompt saving, generation, review, and repeatable outputs
**Filename**: 02-flowchart-repeatable-output.png
EOF

cat > "$PROMPTS_DIR/01-framework-codex-workflow.md" <<'EOF'
---
type: framework
style: blueprint
aspect_ratio: 16:9
---

# Goal
Create a conceptual framework illustration for an article about Codex best practices.

# Core Idea
The real leverage comes from turning one-off prompts into reusable workflows.

# Visual Structure
- A central blueprint-style systems diagram
- Modules labeled: Prompt, Skill, Script, Validation, Reusable Output
- Clear directional arrows showing the flow from messy ad-hoc prompting toward stable repeated execution
- Include one highlighted node labeled “Workflow Reuse”

# Labels
- 一次性提示词
- Skill
- Script
- 验证
- 可复用输出
- Workflow Reuse

# Style
- Clean editorial blueprint illustration
- Deep blue background, light cyan lines, off-white labels
- Geometric shapes, no realistic UI screenshots
- High legibility, balanced spacing, calm technical tone
EOF

cat > "$PROMPTS_DIR/02-flowchart-repeatable-output.md" <<'EOF'
---
type: flowchart
style: blueprint
aspect_ratio: 16:9
---

# Goal
Create a flowchart-style illustration for an article about repeatable Codex workflows.

# Flow
- Input article
- Analyze structure
- Save prompt files
- Generate assets
- Review result
- Reuse the workflow

# Visual Requirements
- Left-to-right process flow with 6 major stages
- Each stage shown as a clean technical card with arrows
- Final stage branches to markdown, translation, image, and slide outputs
- Emphasize that repeatability is the key benefit

# Labels
- 输入文章
- 分析结构
- 保存提示文件
- 生成资产
- 检查结果
- 复用工作流
- Markdown
- Translation
- Image
- Slides

# Style
- Blueprint / product-systems visual language
- Crisp geometry, consistent spacing, no clutter
- Editorial diagram rather than literal software screenshot
EOF

for prompt in \
  "$PROMPTS_DIR/01-framework-codex-workflow.md" \
  "$PROMPTS_DIR/02-flowchart-repeatable-output.md"
do
  base="$(basename "$prompt" .md)"
  image="$OUT_DIR/$base.png"
  if [[ ! -f "$image" ]]; then
    bun "$IMAGINE_DIR/scripts/main.ts" \
      --promptfiles "$prompt" \
      --image "$image" \
      --provider dashscope \
      --model qwen-image-2.0-pro \
      --ar 16:9
    sleep 8
  fi
done

echo "Outline: $OUT_DIR/outline.md"
echo "Images:"
ls -lh "$OUT_DIR"/*.png
