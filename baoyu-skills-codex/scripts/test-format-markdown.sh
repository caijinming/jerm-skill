#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${1:-$ROOT_DIR/tmp/format-markdown-codex}"
FORMAT_DIR="$ROOT_DIR/skills/baoyu-format-markdown/scripts"
HTML_SCRIPT="$ROOT_DIR/scripts/test-markdown-to-html.sh"
SRC="$OUT_DIR/codex-format-source.md"
FORMATTED="$OUT_DIR/codex-format-source-formatted.md"
HTML_OUT="$OUT_DIR/codex-format-source-formatted.html"

mkdir -p "$OUT_DIR"

cat > "$SRC" <<'EOF'
---
title:  Codex格式化测试
summary: 这是一份用于测试markdown格式化的样例
---

# Codex格式化测试

Codex的效果上限，不主要取决于你临场会不会写prompt，而取决于你有没有把工作方式逐步沉淀成一套可复用系统。

如果你已经有了AGENTS.md,skills, scripts 和 tests，那么下一步不是继续堆 prompt，而是先把这些规则固定下来。

这句话很关键： "**先把方法做稳定，再给它排班**"。

- 第一，统一Goal/Context/Constraints/Done when
- 第二，把长期规则写进 "AGENTS.md"
- 第三，让workflow可以重复执行
EOF

cp "$SRC" "$FORMATTED"

if [[ ! -d "$FORMAT_DIR/node_modules" ]]; then
  (cd "$FORMAT_DIR" && bun install)
fi

bun "$FORMAT_DIR/main.ts" "$FORMATTED" --quotes --spacing --emphasis

if [[ ! -f "$FORMATTED" ]]; then
  echo "formatted markdown not found: $FORMATTED" >&2
  exit 1
fi

sh "$HTML_SCRIPT" "$FORMATTED" modern

if [[ ! -f "$HTML_OUT" ]]; then
  echo "expected formatted html not found: $HTML_OUT" >&2
  exit 1
fi

echo "Formatted Markdown: $FORMATTED"
echo "Formatted HTML: $HTML_OUT"
ls -lh "$FORMATTED" "$HTML_OUT"
